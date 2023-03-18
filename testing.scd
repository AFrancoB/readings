

~order.("listaOrdenada");

~file= File(~path++"/test.csv","w");

~file.close

~file= File(~path++"/test.csv","a");

~file.write(~prueba[0].asString.replace("[", "").tr($],$\n))

~prueba[0]
