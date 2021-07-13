# filter left, if possible
Get-ADUser -Filter * | Measure-Object

Measure-Command {
  Get-ADUser -Identity Administrator
}

Measure-Command {
  Get-ADUser -Filter {Name -like "Administrator"}
}

Measure-Command {
  Get-ADUser -Filter * | Where-Object Name -Like "Administrator"
}
