MAIN_MarkerMisplacement.m (main script)
	- MIS_Computation: Function computes a systematic error following the magnitude and direction on the specified marker MARK1 and computes kinematics using PyCGM for each misplacement.
	- MIS_Res_RMSD: Function builts tables containing the RMSD calculations for each of the magnitudes, angles and for all patients.
	- MIS_table_RMSD: Creates a table with RMSD +/- SD and ROM +/- SD for the different angles at 10 mm of marker misplacement.
	- MIS_PlotPolar: Creates a polar plot containing the RMSD for all errors.
	- MIS_PlotCurves: Plot RMSD for one direction (e.g Antero-Posterior) for all magnitudes and only one patient and for one joint.
	- MIS_PlotCurves3: Plot as MIS_PlotCurves but for all lower limb angles at the same time.
	- MIS_anthropometric_data: Gets the anthropometric data (age, height, bodymass, leg length, ankle and knee width)
	- MIS_Correlation: Function calculates the correlation between error and % of leg length for one patient.
	- MIS_Correlation_all: Same as MIS_Correlation but for general population.
	