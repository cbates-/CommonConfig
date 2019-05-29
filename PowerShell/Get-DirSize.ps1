$colItems = (GCI -Recurse | Measure-Object -property length -sum) 
"{0:N2}" -f ($colItems.sum / 1MB) + " MB"
