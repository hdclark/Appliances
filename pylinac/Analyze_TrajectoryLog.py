
from pylinac import load_log, MachineLogs

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

path_to_folder = "/tmp/tlogs/"

logs = MachineLogs(path_to_folder)
logs = load_log(path_to_folder)

i = 0
for log in logs:
    #log.axis_data.mu.plot_actual()
    plotbase = '/tmp/tlogs/plot_' + str(i)
    i = i + 1
    print("Making plot now...")

    # Produce a quick, generic summary (note: doesn't seem to work well, but might as well produce it anyway).
    log.publish_pdf(filename=(plotbase + '_report.pdf'), metadata={'Number of beam holds': log.num_beamholds})

    # Produce specific plots.
    log.axis_data.beam_hold.save_plot_actual(filename=(plotbase + '_beam_holds.pdf'))
    log.axis_data.mu.save_plot_actual(filename=(plotbase + '_MU.pdf'))
    log.axis_data.gantry.save_plot_actual(filename=(plotbase + '_gantry.pdf'))
    #log.axis_data.gantry.save_plot_difference(filename=(plotbase + '_gantry.pdf'))

    # Produce a custom plot.
    plt.close('all') # Reset


    plt.subplot(3, 1, 1)
    plt.title('Sampled Beam Holds, MUs, and Gantry Angles')
    plt.plot( log.axis_data.beam_hold.actual, '-', linewidth=0.5)
    #plt.xlabel('Temporal sample')
    plt.xticks(color='w')
    plt.ylabel('Beam Holds')
    plt.grid()

    plt.subplot(3, 1, 2)
    plt.plot( log.axis_data.mu.actual, '-', linewidth=0.5)
    #plt.xlabel('Temporal sample')
    plt.xticks(color='w')
    plt.ylabel('MU')
    plt.grid()

    plt.subplot(3, 1, 3)
    plt.plot( log.axis_data.gantry.actual, '-', linewidth=0.5)
    plt.xlabel('Temporal sample')
    plt.ylabel('Gantry Angle')
    plt.grid()

    plt.savefig(plotbase + '_beam_holds_MU_and_gantry_angle.pdf')
    plt.show()

quit()

