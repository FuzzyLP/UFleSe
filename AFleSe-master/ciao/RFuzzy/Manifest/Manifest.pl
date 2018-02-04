:- bundle('RFuzzy').
version('1.0').
depends([core]).
alias_paths([
    library = 'lib'
]).
lib('lib').
manual('RFuzzy', [main='doc/SETTINGS.pl']).

