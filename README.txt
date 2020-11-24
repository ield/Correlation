Files to perform the correlation of a cwrm lidar.
/Correlator files:  all files needed to perform the correlation
    main.m:     Run the script ot start the GUI. Select the files to be correlated, 
                the sampling frequency of the signal (unless stated it is 80; the
                sampling frequency is measured in samples per pulse), the frequency
                of the signal of the fpga and whether the signal is measured in air
                or fiber.
    All the other functions are commented. The order of execution normally is:
    corelateFourier (correlates using fft)
        textToSignal: transforms the oscilloscope files
        FourierCorr: performs the correlation
        signalSDR, calculateSNR, etc: to calculate the signal quality.
    correlate (correlates using xcorr)
        textToSignal: transforms the oscilloscope files
        FourierCorr: performs the correlation
        signalSDR, calculateSNR, etc: to calculate the signal quality.
    As it is seen in the GUI, the results are equivalent.
/Measurements:      Different measurements taken using the oscilloscope.
/PlottingFiles:     Files used to plot the results that were used in the TFG
/SimulatingCorrelator:  Generates a verilog input file to use in the testbench
                        of the correlator.
/SimulatingTerminal:    Simulates the output terminal of the .c file.

Enjoy:)
ield