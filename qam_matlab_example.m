% qam_matlab_example.m
% the purpose of this file is to create noisy M-QAM I and Q signals in an
% array of 8-bit signed integers to be used for testing 
% the qam_demapper verilog program.
% Created 4/24/22 by Zach Martin

close all;
clear all;

M = 16;                         % The verilog project uses 16-qam
num_symbols = 100;
filename = "matlab_test_data.txt";
SNR = 3;                       % signal to noise ratio for awgn
x = randi([0 M-1],[1 num_symbols]);    % Create array of random test values
txSig = qammod(x, M);           % Modulate with given inputs
scatterplot(txSig*32)           % show "clean" constellation diagram
rxSig = int8(awgn(txSig,SNR)*32);% Add gaussian noise to signal
scatterplot(rxSig);             % Show "noisy" signal

% Convert signals into hex for test file
I = real(rxSig);
Q = imag(rxSig);

I_hex = dec2hex(I,2);
Q_hex = dec2hex(Q, 2);
Out_hex = dec2hex(x, 2);

% Write signals to text file
file = fopen(filename, 'w');

fprintf(file, "// matlab_test_data.txt. \n// This file is automatically generated from a Matlab script");
fprintf(file, "\n// The data in this file represents noisy 8-bit signed 16qam demodulation");
fprintf(file, "\n// Generated on: ");
fprintf(file, char(datetime()));
fprintf(file, "\n\n//(int8)I_(int8)Q_(uint8)Output\n");

for i = 1:num_symbols
    fprintf(file, I_hex(i, 1:2));
    fprintf(file, "_");
    fprintf(file, Q_hex(i, 1:2));
    fprintf(file, "_");
    fprintf(file, Out_hex(i, 1:2));
    fprintf(file, "\n");
end

fclose(file);
fprintf("\nOperation complete, test file is written to ");
fprintf(filename);
fprintf("\n\n");