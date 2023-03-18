
~path = thisProcess.nowExecutingPath.dirname;


(
~extractArea= { |  area  |
	var path, list, orderedList, ordered, orderedFile, theory, netTech, lc, nm, timeStudies, soundStudies;

	path = ~path;

	list = CSVFileReader.read(path++"/"++"listWithStatus"++".csv");

	orderedList= Array.newClear(list.size);

	(list.size-1).do{|i|
		orderedList.put(i, [list[i+1][0],list[i+1][1],list[i+1][2],list[i+1][3], list[i+1][4], list[i+1][5], list[i+1][1].split($ )[2]]);
	};

	orderedList= orderedList[0..(list.size-2)];
	orderedList= orderedList.sort({|a,b| a[6].asString > b[6] }).reverse;

	ordered= orderedList.collect({|item|  item[0..5] });

	theory= ordered.select({|item|  item[4].contains("theory")  });
	theory.postln;
	netTech= ordered.select({|item|  item[4].contains("network technology")  });
	netTech.postln;
	lc= ordered.select({|item|  item[4].contains("live coding")});
	lc.postln;
	nm= ordered.select({|item|  item[4].contains("network music") });
	nm.postln;
	timeStudies= ordered.select({|item|  item[4].contains("time studies") });
	timeStudies.postln;
	soundStudies= ordered.select({|item| item[4].contains("sound studies") });
	soundStudies.postln;

	area = if(area=="theory", {theory},{
		if(area=="network technology", {netTech}, {
			if(area=="live coding", {lc}, {
				if(area=="network music", {nm}, {
					if(area=="time studies", {timeStudies}, {
						if(area=="sound studies", {soundStudies}, {"area not found".postln})
					})
				})
			})
		})
	});


	("Read " ++ area.select({|item|  item[5].contains("read")  }).size ++ " out of " ++ area.size;).postln;

	area

};

);


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

);

~progress.();

~livecode= ~extractArea.("live coding")

~livecode.collect({| item |    item.postln     })


~time= ~extractArea.("time studies")

~time.collect({| item |    item.postln     })

~sound= ~extractArea.("sound studies")

~sound.collect({| item |    item.postln     })

~net= ~extractArea.("network music")

~net.collect({| item |    item.postln     })

~netech= ~extractArea.("network technology")

~netech.collect({| item |    item[0].postln     })

~theory= ~extractArea.("theory")

~theory.collect({| item |    item[0].postln     })


(
~memorizar= {|area|
	var path, files, chosen, file, reading, author, notes;
	var w, v, b1, b2;

	path = if(area=="all",
		{
			var area = ["lc","nm","nt","ss","th","ts"].choose;
			~path++"/notesForQuiz"++"/"++area;
		},

		{~path++"/notesForQuiz"++"/"++area;});

	files = unixCmdGetStdOut("ls " + path.shellQuote);
	files = files.split($\n);

	// get random number for area
	chosen = files.choose.asString;

	file = TabFileReader.read(path++"/"++chosen);
	file = file.reject({|item|  item.asString == "[  ]" });

	reading = file.select({|item| item.asString.contains(" Reading:")  }).asString[12..].tr($],$ );
	author = file.select({|item| item.asString.contains(" Author:")  });
	notes = File.readAllString(path++"/"++chosen);
	notes = notes[(notes.asString.find("Notes:"))..];

	notes.postln;

	w = Window.new("Notes", Rect(800,10,700,1000)).front;
	w.view.background_(Color.black);
	v = ScrollView(w, Rect(0, 120, 700, (1000-120))).hasBorder_(true);
	v.background_(Color.black);

	b1 = Button(w, Rect(0,0, 700, 60)).font = Font("Helvetica", 20);
	b1.states = [["Reveal Title", Color(0.6,0.99,0.99), Color(0.4,0.4,0.4)],
		[reading.asString, Color.white, Color.black]];

	b2 = Button(w, Rect(0,60, 700, 40)).font = Font("Arial", 20);
	b2.states = [["Reveal Author", Color(0.99,0.6,0.99), Color(0.4,0.4,0.4)],
		[author.asString, Color.white, Color.black]];

	StaticText(v, Rect(0,0,700,5500)).string_(notes.asString).stringColor_(Color.white).align_(\topLeft);


	CmdPeriod.doOnce({ w.close });
	w.refresh;

}
)


~memorizar.("all")


(
~notesPath= ~path++"/notes";


~files = unixCmdGetStdOut("ls " + ~notesPath.shellQuote);


~files = ~files.split($\n);
)

~files.choose


~file = TabFileReader.read(~notesPath++"/"++~files[0]);

~cFile= ~file.reject({|item|  item.asString == "[  ]" });

~extractReading= ~cFile.select({|item| item.asString.contains(" Reading:")  });

~extractAuthor= ~cFile.select({|item| item.asString.contains(" Author:")  });

~extractNotes= File.readAllString(~notesPath++"/"++~files[0]);

~extractNotes= ~extractNotes.asString[(~extractNotes.asString.find("Notes:"))..];



(
w = Window.new("Notes", Rect(800,500,600,600)).front;
w.view.background_(Color.black);

b = Button(w, Rect(0,0, 600, 40));
b.states = [["Reveal Title", Color(0.5,0.8,0.8), Color(0.4,0.4,0.4)],
	[~extractReading.asString, Color.rand, Color.black]];

c = Button(w, Rect(0,30, 600, 40));
c.states = [["Reveal Author", Color(0.8,0.5,0.8), Color(0.4,0.4,0.4)],
	[~extractAuthor.asString, Color.rand, Color.black]];

StaticText(w, Rect(0,120,200,200)).string_(~extractNotes.asString).stringColor_(Color.white);

CmdPeriod.doOnce({ w.close });
w.refresh;
)
















// What is a network? 8
'Introduction' in Network Aesthetics.                                               [*]

Physical Media ? Chapter 1 in protocol: how control exists after decentralization   [+]
Two bits: The cultural significance of free software                                [+]
Coding Freedom: The Ethics and Aesthetics of Hacking                                [+]

The Models - Chapter 1 in The Stack: On Software and Sovereignty                    [+]

Affective Networks

What is new media? - Chapter 1 in The language of new media

Refraining - Chapter 2 in An Aesthesia of Networks: Conjunctive Experience in Art and Technology
The Temporality of Networks
Timeless time


// discussion of the general intellect
Marx                                                                                [+]
Berardi
Fuchs                                                                               [+]
Karl Marx at internet studies                                                       [+]
Communicative Capitalism and Revolutionary Form                                     [+]

// theory for networks
Agential Realism How Material-Discursive Practices Matter
Vibrant Matter - The Agency of Assemblages
Vibrant Matter - Political Ecologies
The Desiring Machines - Chapter 1 in Anti-Oedipus : capitalism and schizophrenia
Micropolitiques and segmentaerity - A Thousand Plateaus
The refrain - A Thousand Plateaus
Treaty on nomadology - A Thousand Plateaus
Capitalism and Fascism of Everyday Life - Resistance Revolution and Fascism: Zapatismo and Assemblage Politics
Resistance to the Future: Constructing Space in Time - Resistance Revolution and Fascism: Zapatismo and Assemblage Politics
Resistance: Zapatismo and Assemblage Politics - Resistance Revolution and Fascism: Zapatismo and Assemblage Politics
Revolution and Fascism - Resistance Revolution and Fascism: Zapatismo and Assemblage Politics

// networked subjects 6
DIGITAL SOVEREIGNTY OR DIGITAL COLONIALISM? New tensions of privacy security and national policies [+]
Data colonialism: Rethinking big data?s relation to the contemporary subject                       [+]
From digital divides to the first mile: Indigenous peoples and the network society in Canada       [+]
Invisibly Visible Visibly Invisible - Chapter 1 in Programmed Visions: Software and Memory
Cyberwar?s Subjects - In Cyberwar and Revolution: Digital Subterfuge in Global Capitalism
Everything is Animated: Pervasive Media and the Networked Subject


// tech theory
Making the beings of Technology Visible


// what is infrastructure? 14
The Politics and Poetics of Infrastructure
A Material History of Bits
Computing as If Infrastructure Mattered
The right to infrastructure: A prototype for open source urbanism
Infrastructure and Modernity: Force Time and Social Organization in the History of Sociotechnical Systems
Understanding Infrastructure: History Heuristics and Cyberinfrastructure Policy
Infrastructure studies meet platform studies in the age of Google and Facebook
Introduction to Logistical Media Theory
Imperial Infrastructures
Sovereign Media and the Ruins of a Logistical Future
How Infrastructures Matter
The ethnography of infrastructure. American Behavioral Scientist
Do Artifacts Have Politics?
The construction of platform imperialism in the globalization era















