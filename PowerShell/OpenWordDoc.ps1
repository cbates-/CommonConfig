$Filename='C:\HappyBirthdayEd.docx'

$Word=NEW-Object –comobject Word.Application

$Document=$Word.documents.open($Filename)
