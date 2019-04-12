:- bundle('RFuzzy').
version('1.0').
depends([core-[version>='1.18']]).
alias_paths([
    library = 'lib'
]).
lib('lib').
manual('RFuzzy', [main='doc/SETTINGS.pl']).

