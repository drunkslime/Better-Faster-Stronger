$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress)[4]

$text = Get-Content -Path .\lib\services\database_service.dart | Foreach-Object { $_ -replace 'final address =.*', ("final address = " + "'$ipv4" + ":8000';") } 

Set-Content -Path .\lib\services\database_service.dart -Value $text     

python "bfserver\manage.py" runserver 0.0.0.0:8000