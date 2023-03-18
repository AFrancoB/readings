// Book Capture page

// Theory:

// Anthony Faramelli: "Resistance, Revolution and Fascism Zapatismo and Assemblage Politics",
//                    "Digital Resistance"


~path = thisProcess.nowExecutingPath.dirname;


~notes = {|name, author, zone, pages, biblio, links, list, notes|

	var path = ~path;
	var file = File(path++"/notes/"++name++".txt", "w");
	var lista = File(path++"/laLista.csv","a");
	var units = (pages/30);

	file.write(
		"Reading: "++name.asString ++"\n"++"\n"++
		"Author: "++author.asString++"\n"++"\n"++
		"Units: "++units.asString++
		", Zone:"++zone.asString++"\n"++"\n"++
		"Bibliography:"++biblio.asString++"\n"++"\n"++
		"Links:"++links.asString++"\n"++"\n"++"\n"++
		"Notes:"++"\n"++ notes.asString
	);
	file.close;

	if(list== True, {
		lista.write(
			name.asString.tr($, , $ ) ++ ", " ++
			author.asString ++ ", " ++
			units.asString ++ ", " ++
			pages.asString ++ ", " ++
			zone.asString ++ "\n"
		); lista.close;
		(name.asString++" has been included in the reading list").postln
	},
	{"not included in the reading list".postln});



};

~order = {|newFile|
	var path, list, orderedList, ordered, orderedFile, theory, netTech, lcNm, timeSoundStudies;

	path= ~path;
	list= CSVFileReader.read(~path++"/laLista.csv");
	newFile= path++"/"++newFile++".csv";
	orderedList= Array.newClear(list.size);

	(list.size-1).do{|i|
		orderedList.put(i, [list[i+1][0],list[i+1][1],list[i+1][2],list[i+1][3], list[i+1][4], list[i+1][1].split($ )[2]]);
	};
	orderedList= orderedList[0..(list.size-2)];
	orderedList= orderedList.sort({|a,b| a[5].asString > b[5] }).reverse;

	ordered= orderedList.collect({|item|  item[0..4] });

	theory= ordered.select({|item|  item[4].contains("theory")  });
	theory.postln;
	netTech= ordered.select({|item|  item[4].contains("network technology")  });
	netTech.postln;
	lcNm= ordered.select({|item|  item[4].contains("live coding") || item[4].contains("network music") });
	lcNm.postln;
	timeSoundStudies= ordered.select({|item|  item[4].contains("time studies") || item[4].contains("sound studies") });
	timeSoundStudies.postln;

	ordered= theory ++ netTech ++ lcNm ++ timeSoundStudies;

	// create file;
	orderedFile= File(newFile, "w");
	orderedFile.write("Reading Name, Author, Units, Pages"++"\n");
	orderedFile.close;

	ordered.collect({|item|
		orderedFile= File(newFile, "a");
		orderedFile.write(item.asString.replace("[", "").tr($],$\n));
		orderedFile.close
	})

};

// function to look for key words from notes

/*~lookFor= {|keyWords, manyNotes, zone, whichList|
	var path = ~path
	var notes = path++"/notes/"
	var list = path++"whichList"++".csv";

	// choose the books from the list according to area
	// access each note and look for set of keywords
	// books that contain this words choose the top manyNotes of books containing this words

}*/



