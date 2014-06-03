% ----------------------------------------------------------------------- %
% % test function                                                       % %
% % Run backward induction for a hypothetical household to test program % % 
% ----------------------------------------------------------------------- %

function test(gv)

gv.arglist.mode = 0;
% Run indivmodel to find out optimal decisions for the specific household;
gv = indivmodel(gv);

% Calculate results
firstage = gv.calc.firstage;
lastage = gv.calc.lastage;
ret0mat(1:lastage-fristage,1) = 100* gv.arglist.ret0mat(1,firstage-50+1:lastage-50+1); % Percent of individuals who are not in their career job; ???
ret1mat(1:lastage-fristage,1) = 100* gv.arglist.ret1mat(1,firstage-50+1:lastage-50+1); % Cumulative percent of retiring from fulltime job to part time job or full retirement;
ret2mat(1:lastage-fristage,1) = 100* gv.arglist.ret2mat(1,firstage-50+1:lastage-50+1); % Cumultive percent from full time job to full retirement;
returnft(1:lastage-fristage,1) = 100 * gv.arglist.returnft(1,firstage-50+1:lastage-50+1); % Percent newly return to full time work, previously retired;
returnpt(1:lastage-fristage,1) = 100 * gv.arglist.returnpt(1,firstage-50+1:lastage-50+1); % Percent newly return to part time work, previously retired;
newpt(1:lastage-fristage,1)  = 100 * gv.arglist.newpt(1,firstage-50+1:lastage-50+1); % Percent newly enter part time work;
everreturnft = 100 * gv.arglist.everreturnft(1,1); % Percent return to full time work after full or partial retirement;
everreturnpt = 100 * gv.arglist.everreturnpt(1,1); % Percent return to part time work after full retirement;
everreturn   = 100 * gv.arglist.everreturn(1,1); % Percent return to full time work after full or partial retirement or returning to part time work after full retirement;

% Output; Print and save tabulations;
fprintf('\n\n                Percent                   Percent');
fprintf(  '\n            Pseudo-Retiring               Retired');
fprintf(  '\n           From                       From');
fprintf(  '\nAge       FT Work  Completely        FT Work  Completely');
fprintf(  '\n');
fprintf('\n %2d                                  %5.1f     %5.1f',firstage, ret1mat(firstage - 50+1), ret2mat(firstage - 50+1));
fprintf('\n %2d       %5.1f    %5.1f             %5.1f     %5.1f', (firstage+1:lastage)',...
        ret1mat(2:end,1)-ret1mat(1:end-1,1), ret2mat(2:end,1) - ret2mat(1:end-1,1),...
        ret1mat(:,1), ret2mat(:,1));

fprintf('\n\n\n                       Percent    Percent                          Percent Newly');
fprintf(    '\n                         in        Newly                   Percent   Returned');
fprintf(    '\n        Percent        FT Work    Returned       Percent    Newly   to PT Work');
fprintf(    '\nAge     in Main         after       to             in        in     Previously');
fprintf(    '\n          Job          Retiring   FT Work        PT Work   PT Work   Retired');
fprintf(    '\n');
fprintf('\n %2d      %5.1f                                   %5.1f',...
    firstage, 100-ret0mat(1,1), ret1mat(1,1)-ret2mat(1,1));
fprintf('\n %2d      %5.1f          %5.1f     %5.1f          %5.1f     %5.1f     %5.1f', (firstage+1:lastage)',...
    100-ret0mat(:,1), ret0mat(:,1)-ret1mat(:,1), returnft(:,1),...
    ret1mat(:,1)-ret2mat(:,1), newpt(:,1), returnpt(:,1));

fprintf('\n\nPercent returning to full time work after full or partial retirement: %5.1f', everreturnft);
fprintf('\nPercent returning to part time work after full retirement: %5.1f', everreturnpt);
fprintf('\nPercent returning to full time work after full or partial retirement');
fprintf('\n  or returning to part time work after full retirement: %5.1f', everreturn);



















