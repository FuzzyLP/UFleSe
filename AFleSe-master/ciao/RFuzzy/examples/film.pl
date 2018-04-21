:- module(film,_,[rfuzzy, clpr]).
% :- module(db_leisure,_,[rfuzzy, clpr, pkgs_output_debug]).
% Compilation time debug can be activated  by adding to the packages list [rfuzzy, clpr] the package pkgs_output_debug.
% Running time debug can be activated removing the comment marker % at the beginning of the following line.
% :- activate_rfuzzy_debug.

% Define the films database format.
define_database(film/8, 
	[(film_name, rfuzzy_string_type), 
	  (release_year, rfuzzy_integer_type), 
	   (duration_in_minutes, rfuzzy_integer_type),
	    (genre, rfuzzy_enum_type), 
	     (original_language, rfuzzy_enum_type), 
	      (directed_by, rfuzzy_enum_type), 
	       (distributed_by, rfuzzy_enum_type),
		(not_for_children_under, rfuzzy_integer_type)]).

film('The Godfather', 1972, 207, drama, english, 'Francis Ford Coppola', 'Paramount Pictures', 12).
film('Casablanca', 1946, 172, romance, english, 'Michael Curtiz', 'Warner Bros', null).
film('Cera una volta il West', 1968, 165, western, italian, 'Sergio Leone', 'MYMONETRO', null).
film('El laberinto del fauno', 2006, 107, drama, spanish, 'Guillermo del Toro', 'Esperanto Films', 12).
film('Il buono, il brutto, il cattivo', 1967, 141, adventure, italian, 'Sergio Leone', 'United Artists', null).
film('Finding Nemo', 2003, 112, comedy, english, 'Andrew Stanton and Lee Unkrich', 'Disney - PIXAR', null).
film('Thor - The dark world', 2013, 90, action, english, 'Alan Taylor', 'Walt Disney Studios Motion Pictures', null).
film('Blue Jasmine', 2013, 98, action, english, 'Woody Allen', 'Warner Bros', null).
film('The Collection', 2013, 82, thriller, english, 'Marcus Dunstan', 'Alimpro Films', null).
film('Before Sunrise', 1995, 101, romantic_drama, english, 'Richard Linklater', 'Columbia Pictures', null).
film('Before Midnight', 2013, 109, romantic_drama, english, 'Richard Linklater', 'Sony Pictures Classics', null).
film('Quien mato a Bambi?', 2013, 89, comedy, spanish, 'Santi Amodeo', 'Sony Pictures', 12).
film('Not Suitable for Children', 2012, 96, romantic_comedy, english, 'Peter Templeman', 'Icon Film Distribution', null).
film('Despicable Me', 2010, 95, comedy, english, 'Pierre Coffin and Chris Renaud', 'Universal Pictures', 0).
film('Despicable Me 2', 2013, 98, comedy, english, 'Pierre Coffin and Chris Renaud', 'Universal Pictures', 0).
film('Wall-E', 2008, 98, romantic_comedy, english, 'Andrew Stanton', 'Walt Disney Studios Motion Pictures', 0).
film('Ice Age', 2002, 81, computer-animated_comedy-drama_adventure, english, 'Carlos Saldanha and Chris Wedge', '20th Century Fox', 0).
film('Ice Age: The Meltdown', 2006, 91, computer-animated_comedy_adventure, english, 'Carlos Saldanha', '20th Century Fox', 0).
film('Ice Age: Dawn of the Dinosaurs', 2009, 94, computer-animated_comedy_adventure, english, 'Carlos Saldanha', '20th Century Fox', 0).
film('Ice Age: Continental Drift', 2012, 88, computer-animated_comedy_adventure, english, 'Steve Martino and Mike Thurmeier', '20th Century Fox', 0).
film('Shrek', 2001, 90, computer-animated_fantasy-comedy, english, 'Andrew Adamson and Vicky Jenson', 'DreamWorks Pictures', 0).
film('Shrek 2', 2004, 92, computer-animated_fantasy-comedy, english, 'Andrew Adamson, Kelly Asbury and Conrad Vernon', 'DreamWorks Pictures', 0).
film('Shrek 3', 2007, 93, computer-animated_fantasy-comedy, english, 'Chris Miller and Raman Hui', 'Paramount Pictures', 0).
film('Shrek Forever After', 2010, 93, computer-animated_fantasy-comedy, english, 'Mike Mitchell', 'Paramount Pictures', 0).

