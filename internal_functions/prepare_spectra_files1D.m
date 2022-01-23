
function list_of_spectra_1D = prepare_spectra_files1D(Spectra_1D_folder)

    list_of_spectra_1D = Take_spectra_folders(Spectra_1D_folder);

end

function [Spectra_folders] = Take_spectra_folders(parentDir)

    files    = dir(parentDir);
    names    = {files.name};
    dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
    Spectra_folders = transpose(names(dirFlags));

end