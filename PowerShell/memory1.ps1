$m = ps chrome  | measure PM -Sum ; ("Chrome PM {0:N2}MB " -f ($m.sum / 1mb))
$m = ps chrome  | measure VM -Sum ; ("Chrome VM {0:N2}MB " -f ($m.sum / 1mb))

$m = ps firefox | measure PM -Sum ; ("Firefox PM {0:N2}MB " -f ($m.sum / 1mb))
$m = ps firefox | measure VM -Sum ; ("Firefox VM {0:N2}MB " -f ($m.sum / 1mb))

$m = ps iexplore| measure PM -Sum ; ("IE      PM {0:N2}MB " -f ($m.sum / 1mb))
$m = ps iexplore| measure VM -Sum ; ("IE      VM {0:N2}MB " -f ($m.sum / 1mb))
