class ShowcaseController < ApplicationController
  require 'timeout'

  def index
    # Launch jupyter notebook in subprocess/daemon
    (pid = fork) ? Process.detach(pid) : exec("jupyter notebook public/jupyter_notebooks/Test.ipynb")
    # system('jupyter notebook public/jupyter_notebooks/Test.ipynb')
  end

  def perform_calc
    # Sometimes (after restarting computer) python script fails because the download
    # keys don't match up for the image dataset. Need to   rm /tmp/imagenet/inception-2015-12-05.tgz
    # and run script again

    # Runs the image classification example
    command = 'python ' + Rails.root.to_s + '/lib/python_scripts/models/tutorials/image/imagenet/classify_image.py'

    # Runs the classification on the image neame provided to params, otherwise defaults to the panda example.
    if params[:image_name]
      # @image is what we display on the page
      @image = Rails.root.to_s + '/public/images/' + params[:image_name]

      # this specifies the image to the classifier
      command += ' --image_file ' + @image
    else
      @image = Rails.root.to_s + '/public/images/cropped_panda.jpg'
    end



    # ---- Clutch code from https://stackoverflow.com/questions/12189904/fork-child-process-with-timeout-and-capture-output ----
    # stdout, stderr pipes
    rout, wout = IO.pipe
    rerr, werr = IO.pipe

    pid = Process.spawn(command, :out => wout, :err => werr)
    _, status = Process.wait2(pid)

    # close write ends so we could read them
    wout.close
    werr.close

    @result = rout.readlines
    @errors = rerr.readlines

    # dispose the read ends of the pipes
    rout.close
    rerr.close

    @last_exit_status = status.exitstatus
    # ---- End clutch code -----

  end

  def home

  end

end
