
~path = thisProcess.nowExecutingPath.dirname;

// function to count units read
/*~count*/


/*// function to scratch readings
~out = {};*/



~defListEntries = { |listName|

	var path = ~path;
	var list = CSVFileReader.read(path++"/"++listName++".csv"); // extract the name of the notes from a list

	var getName = list.collect({|item|   item[0][1..]   })[1..];

	var extractFromNotes;

	getName.postln;

	extractFromNotes = getName.collect({|item, iter|

		var fromFile = TabFileReader.read(path++"/notes/"++item.asString++".txt");

		fromFile[0]++"\n"++fromFile[2]++"\n"++fromFile[4]++"\n"++fromFile[6];
	});

	extractFromNotes
};

~defListWriter.(~defListEntries.("listaOrdenada"), "definitiveList_AFB");

~defListWriter = {|listOfEntries, nameOfList|

	var path = ~path;
	var filePath = path++"/"++nameOfList++".txt";
	var newFile = File(filePath,"w");
	var defList = newFile.write("Reading list - Alejandro Franco Briones" ++ "\n" ++ "\n");

	defList.close;

	listOfEntries.collect({|item,iter|


		var orderedFile= File(filePath, "a");
		orderedFile.write((iter+1).asString ++ " " ++ item.asString.replace("[", "- ").tr($],$\n)++"\n");
		orderedFile.close


	})


};



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

~query = {|zoneString|
	var path, list, orderedList, ordered, orderedFile, theory, netTech, lc, nm, ts, ss, zone;

	path= ~path;
	list= CSVFileReader.read(~path++"/laLista.csv");
//	newFile= path++"/"++newFile++".csv";
	orderedList= Array.newClear(list.size);

	(list.size-1).do{|i|
		orderedList.put(i, [list[i+1][0],list[i+1][1],list[i+1][2],list[i+1][3], list[i+1][4], list[i+1][1].split($ )[2]]);
	};
	orderedList= orderedList[0..(list.size-2)];
	orderedList= orderedList.sort({|a,b| a[5].asString > b[5] }).reverse;

	ordered= orderedList.collect({|item|  item[0..4] });

	theory= ordered.select({|item|  item[4].contains("theory")  });
	netTech= ordered.select({|item|  item[4].contains("network technology")  });
	lc= ordered.select({|item|  item[4].contains("live coding") });
	nm= ordered.select({|item|  item[4].contains("network music") });
	ts= ordered.select({|item|  item[4].contains("time studies") });
	ss= ordered.select({|item|  item[4].contains("sound studies") });

	zone = switch(zoneString,
		"theory", theory,
		"network technology", netTech,
		"live coding", lc,
		"network music", nm,
		"time studies", ts,
		"sound studies", ss
	);

	(
		"The zone" + zoneString + "has:" ++ "\n" ++
	// how many items for this zone?
		"Items:" + zone.size.asString ++ "\n" ++

	// how many units?
		"Units:" + zone.collect({|item| item[2].asFloat }).sum.asString ++ "\n" ++

	// how many pages?

		"Pages:" + zone.collect({|item| item[3].asFloat }).sum.asString;
	).postln;

	zone

};


// extract from the bibliography the part of it that starts with pp. And then counts the number of pages of given article
~idPages= {|bibliostring|
	var index= bibliostring.find("pp.");
	var getPagesIndexes = bibliostring[index..(bibliostring.size)];
	if( index == nil, {"There are no page numbers or they are not formatted correctly. Consider modifying the bibliography before inputting it into thr system".postln}, {~countPages.(getPagesIndexes)});
};

~countPages= {|string|  ( 1 + string.split($.)[1].split($-)[1].asFloat) - string.split($.)[1].split($-)[0].asFloat   };


~lookFor= {|string, whereToLook|
	var path, list, look, whatZone;

	path= ~path;
	list= CSVFileReader.read(~path++"/laLista.csv");
	whatZone = switch(whereToLook,
		"author", list.select({|item|  item[1].asString.containsi(string)    }),
		"reading", list.select({|item|  item[0].asString.containsi(string)    }),
		"zone", list.select({|item|  item[4].asString.containsi(string)    })
	)
};


(// function to look for entry provided id name and add a reading status: done, reading, found, to find
~getStatus= {|readingID, newStatus|
	var path, list, read, ind, head, toChange;

	path= ~path;
	list= CSVFileReader.read(~path++"/listWithStatus.csv");
	read= list.select({|item|  item[0].asString.containsi(readingID)    });
	read= read[0];
	ind= list.detectIndex({|item|  item == read });

	toChange= (index: ind, reading: read.insert(5,newStatus));

	head = list[0].extend(6, "Status");
	list = list[1..];
	list = [head] ++ list;
	("The reading is: "+read[0]).postln;
	("By:" +read[1]).postln;
	list.put(toChange.index,toChange.reading)


};
)

~list= [[1,2,3],[3,4,5]]

a = ~list[0].extend(4,nil)


(
// if you are starting a new list from laLista you need to change the path accordingly. If you are adding a new status to an existing list just keep the path to the listWithStatus;
~addStatusToList= {|readingID, newStatusStr, nameOfList|

	var path = ~path;
	var filePath = path++"/"++nameOfList++".csv";
	var newStatus = ~trimEntry.(~getStatus.(readingID, newStatusStr));
	var file = File(filePath,"w");

	newStatus.collect({|item| file.write(  ~trim.(item.asString.tr($[,$ ).tr($],$ )) ++ "\n"  )});

	file.close

}
)

// helpers ----- trimmm entries!!!!
~trim = {|string|  string.reject({|item, iter| (iter==0 && item == Char.space) ||  (item == Char.space && string[iter-1] == Char.space )})  };
~trimEntry = {|array|  array.collect({|item| ~trim.(item)}) };



~getStatus.("part III","");
~addStatusToList.("part III","read", "listWithStatus")

// function to look for key words from notes

/*~lookFor= {|keyWords, manyNotes, zone, whichList|
	var path = ~path
	var notes = path++"/notes/"
	var list = path++"whichList"++".csv";

	// choose the books from the list according to area
	// access each note and look for set of keywords
	// books that contain this words choose the top manyNotes of books containing this words

}*/

(
~progress = {
	var path, list, orderedList, ordered, totalUnits, totalPages, units, pages;

	path= ~path;
	list= CSVFileReader.read(~path++"/listWithStatus.csv");
//	newFile= path++"/"++newFile++".csv";
	orderedList= Array.newClear(list.size);

	(list.size-1).do{|i|
		orderedList.put(i, [list[i+1][0],list[i+1][1],list[i+1][2],list[i+1][3], list[i+1][4], list[i+1][5], list[i+1][1].split($ )[2]]);
	};
	orderedList= orderedList[0..(list.size-2)];
	orderedList= orderedList.sort({|a,b| a[6].asString > b[6] }).reverse;

	ordered= orderedList.collect({|item|  item[0..5] });

	totalUnits= ordered.collect({|item|  item[2].asFloat  });
	totalPages= ordered.collect({|item|  item[3].asFloat  });

	ordered= ordered.select({|item|  item[5].asString.containsi("read")    });

	units= ordered.collect({|item|   item[2].asFloat  }).sum; // 2 untis // 3 pages
	pages= ordered.collect({|item|   item[3].asFloat  }).sum;
	totalUnits = totalUnits.sum;
	totalPages = totalPages.sum;

	("You have advanced " ++ units ++ " out of " ++ totalUnits ++ " units.").postln;
	("You have read " ++ pages ++ " out of " ++ totalPages ++" pages.").postln;
	(((units*100)/totalUnits).asString[0..4] ++ "% advanced so far").postln;

	(list:ordered, data: (units: units, totalUnits: totalUnits, pages: pages, totalPages: totalPages))

};

)

~progress.();
~progress.().data.totalUnits;


(
~chooseColour = {|list, item, light|
	var set = Set.new;
	var categories;

	list.collect({|item|   set.add(item[4])    });
	categories = set.as(Array).sort({|a,b|  a > b }).reverse;

	switch(item,
		categories[0],Color(0.75, 0.75, 0), // live coding
		categories[1],Color(0, 0.7   ,0),          // network music
		categories[2],Color(0,  0,  0.5),          // network tech
		categories[3],Color(0.7,  0,  0),          // sound studies
		categories[4],Color(0.5,0.5,0.5),          // theory - crit theory
		categories[5],Color(0.5,0.5,0.5),          // theory - crit theo : ANT
		categories[6],Color(0.5,0.5,0.5),          // theory - crit theo : ANT
		categories[7],Color(0.4,0.4,0.4),          // theory - crit theo : poststructuralism
		categories[8],Color(0.5, 0,0.5),          // time studies
	)

};

// input data of a list of already read test and effects a visualisation of it.
~visualise = {| data |
	var units= data.data.units, total= data.data.totalUnits, list= data.list;
	var xPos=500, yPos=250, width=700, height=500;
	var wind = Window("Display",Rect(xPos,yPos,width,height));
	var userV = UserView(wind, Rect(0,0,width, height));

	var controlWindow, w; // get rid of w
	var matrix = [0,0];
	var sliders, spex, name;
	var txF, sTx;

	var startX;
	var mouseDownFunc = {|me, x, y, mod|
    startX = x;
		x.postln;
    postf("begin path: x=% realtive mouse coordinates:%\n",startX, x@y);
		if(x<100, {}, {});

};

	var dataPi = units.linlin(0,total,0,2);

	// create a controller-window
	controlWindow = Window("matrix controls", Rect(400,200,350,120));
	controlWindow.front;

	controlWindow.view.decorator = sliders = FlowLayout(controlWindow.view.bounds);
	spex = [
		[0, 2.0].asSpec,
		[0, 2.0].asSpec
	];
	name = #[slider1,slider2];

	sTx = StaticText(controlWindow, Rect(100,30,100,20));
	sTx.string = "Look for a text:";


	txF = TextField(controlWindow, Rect(100,30,250,20));
	txF.string = "The Southern Question";

	txF.action = {|field|  //field.value.postln;
		var usW = UserView(wind, Rect(0,0,width,height));
		var toAmplify = ~find.(field.value.asString, list);
		var stTx = StaticText(wind,Rect(0,0, width, 30));



		usW.drawFunc = {
			var color = ~chooseColour.(list, toAmplify.reading[4]).vary;
			Pen.fillColor = color;
			stTx.stringColor = color;
		//	stTx.string = toAmplify.reading;

			Pen.addWedge(
				Point(width/2,height/2),
				/*if(toAmplify.reading.asFloat[2]<0.25, {280},{255})*/255,
				if(toAmplify.index.asInt==0,
					{1pi},
					{ 1pi + Array.fill(toAmplify.index.asInt,{|i| list[i][2]}).asFloat.sum.linlin(0,total,0,2pi)})

				,toAmplify.reading[2].asFloat.linlin(0,total,0,2pi));

			Pen.perform([\fill]);


		};
	};

	2.do { |i|
		EZSlider(controlWindow, 200 @ 20, name[i], spex[i], { |ez| var val;
			val = ez.value;
			[i, val.round(10e-3)].postln;
			matrix.put(i, val);
			wind.refresh; // reevaluate drawFunc function
		}, 0);
		sliders.nextLine;
	};

	wind.view.background_(Color(0.2,0.2,0.25));


	userV.drawFunc = {|dataToDraw|


		list.collect({|item,iter|
			Pen.fillColor =~chooseColour.(data.list, item[4]);
			Pen.addWedge(
				Point(width/2,height/2),
				250,
				if(iter==0, {1pi}, { 1pi + Array.fill(iter,{|i| list[i][2]}).asFloat.sum.linlin(0,total,0,2pi) }),
				item[2].asFloat.linlin(0,total,0,2pi)
			);
			item[0].postln;


    Pen.strokeColor = Color.white;
			Pen.perform([\fill]);
			Pen.perform([\stroke]);

			});


		Pen.color = Color(0.4,0.4,0.4);
		Pen.addWedge(Point(width/2,height/2),245,1pi + (dataPi*pi),(2pi - (dataPi*pi)));
		Pen.perform([\stroke]);
	};

	userV.mouseDownAction = mouseDownFunc;

	wind.front;
	CmdPeriod.doOnce({ wind.close; controlWindow.close });


};
~visualise.(~progress.())
)


(// function to look for entry provided id name and add a reading status: done, reading, found, to find
~find= {|readingID, list|
	var path, read, ind, head, toChange;

	read= list.select({|item|  item[0].asString.containsi(readingID)    });
	read= read[0];
	ind= list.detectIndex({|item|  item == read });

	(index: ind, reading: read).postln;
}
)

// 45 paginas al día, 5 dias a la semana por tres meses.



