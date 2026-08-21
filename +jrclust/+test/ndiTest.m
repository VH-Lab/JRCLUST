classdef ndiTest < matlab.uitest.TestCase & matlab.mock.TestCase
	methods(Test)
		function testNDIBootstrapAndDetect(tc)
			% use mock session
			S = ndi.session.mock();
			P = S.getprobes('type','n-trode');
			E = S.getelements('element.type','n-trode');
			E = E{1};
			jrc('bootstrap','ndi',S,E,'noShow');

			% the parameter folder is named for the element by
			% ndi.fun.file.elementDirectoryName; its name must be legal on
			% every platform, so it must not contain '|' (illegal on Windows)
			[paramdir, dirname] = ndi.fun.file.elementDirectory([S.path() filesep '.JRCLUST'], E);

			tc.verifyTrue(isfolder(paramdir), ...
				['Bootstrap did not create the parameter folder ' paramdir '.']);

			tc.verifyEmpty(strfind(dirname,'|'), ...
				['Parameter folder name ''' dirname ''' contains a ''|'', which is not a legal filename character on Windows.']);

			paramfile = [paramdir filesep 'jrclust.prm'];

			eval(['jrc detect ' paramfile]);
		end;
	end;
end
