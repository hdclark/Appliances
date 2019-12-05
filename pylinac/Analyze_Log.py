
from pylinac import load_log
from pylinac import log_analyzer

#logs_path = "/tmp/A20191202084129_1937015.dlg"
dlogs_path = "/tmp/"

dlogs = load_log(dlogs_path)

#dlogs.report_basic_parameters()

for dlog in dlogs:
    #dlog.report_basic_parameters()
    #dlog.plot_summary()
    #log_analyzer.Axis( dlog.axis_data.gantry.actual, dlog.axis_data.beam_hold.actual).save_plot_difference(filename='diff.png')
    plotname = dlog.a_logfile + '.png'
    log_analyzer.Axis( dlog.axis_data.beam_hold.actual).save_plot_actual(filename=plotname)
    #dlog.axis_data.gantry.actual
    #dlog.axis_data.beam_hold.actual
    #dlog.axis_data.gantry.actual
    #dlog.publish_pdf("/tmp/LogAnalysisReport.pdf")
    #dlog.axis_data.mu.plot_actual()


#dlogs.axis_data.gantry.plot_actual()  # plot the gantry position throughout treatment
#dlogs.fluence.gamma.calc_map(doseTA=1, distTA=1, threshold=10, resolution=0.1)
#dlogs.fluence.gamma.plot_map()  # show the gamma map as a matplotlib figure
#dlogs.publish_pdf()  # publish a PDF report

