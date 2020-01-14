
from pylinac import load_log, MachineLogs

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
    log.axis_data.mu.save_plot_actual(filename=(plotbase + '_MU.png'))
    log.axis_data.beam_hold.save_plot_actual(filename=(plotbase + '_beam_holds.png'))
    #log.axis_data.gantry.save_plot_difference(filename=(plotbase + '_gantry.png'))

quit()

