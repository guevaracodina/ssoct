function [Imout frameout frameReadOut fileNo] = LectureImageMultiFast(Path,file,frameToRead)
%Path :le repertoire contenant les fichiers .bin
% file: name of file   (ex: image)
%frameToRead: frame to read, -1 this return the first image
% then take the proper line in FrameReadOut to select the good frame to read
% note, if frameToRead contain 1 line, Imout est une matrix
%if frameToRead is a vector, Imout is a cell
% frameReadOut : frames present in the file (frameNo  indexInFileNo fileNo)
% fileNo : number of the file containing image
persistent zzz filenameOld  PathOld s1 s2 frameReadOutold
Imout=[];
frameout =[];
frameReadOut=[];
fileNo=[];
if nargin==0
    clear zzz filenameOld  PathOld s1 s2
    return
end
if ~strcmp(Path(end),'\')
    Path=[Path '\'];
end

%% open first file to see the size of the image or extract figure 1
if ~strcmp(Path ,PathOld) || frameToRead(1)==-1 
    fidA = fopen([Path file '0.bin']);
    I = fread(fidA,5,'int32');    
    s2= I(3);
    s1= I(2);
    if frameToRead(1)==-1 && nargout==1 % just load first image
        zz=int16((fread(fidA,s1*s2,'int16')));
        Imout=double(reshape(zz,s1,s2))';  
        fclose(fidA);
        filename00Old= [Path file '0.bin'];        
        return
    end
    fclose(fidA);
   
end

if nargout>=3 
   % extract frameReadOut i.e. all the frame present in the directory
   fichier=dir([Path file '*.bin']);
  % disp('just first file execute modify the file')
    for i1=1:length(fichier)
        fileNo(i1)=str2num(fichier(i1).name(length(file)+1:end-4));
    end
    [fileNo indexFile]=sort(fileNo);    
    frameReadOut=zeros(100000,3);
    indA=1;
    for i1=1:length(indexFile)
        
        fidA = fopen([Path fichier(indexFile(i1)).name]);
        EOF=0;
        indB=1;
        while  EOF==0
            try
                [ frameReadOut(indA,1)  count]= fread(fidA,1,'int32');
                [~]=fread(fidA,s1*s2+4,'int16');
                frameReadOut(indA,2)=indB;
                frameReadOut(indA,3)=fileNo(i1);
                indA=indA+1; indB=indB+1;
            catch
                EOF=1;
            end
        end
        fclose(fidA);
    end
    frameReadOut(indA:end,:)=[];
    frameReadOutold=frameReadOut;
    PathOld= Path ;
    return
end


if size(frameToRead,2)==1 
    % read from the frameReadOut to open the good .bin and take the proper
    % position in the file
    if ~isempty(frameReadOut) 
    elseif (isempty(frameReadOutold) || ~strcmp(Path,PathOld))
        load([Path 'info.mat'],'info1');
        frameReadOut=info1.FrameIndex;
        frameReadOutold=frameReadOut;
        PathOld= Path ;
    else
        frameReadOut=frameReadOutold;
    end
    frameToRead=frameReadOut(frameReadOut(:,1)==frameToRead,:);
end
    
%% lecture du .bin
for i1=1:size(frameToRead,1)
    filename=[Path file num2str(frameToRead(i1,3)) '.bin'];
    if ~strcmp(filename,filenameOld) %lecture of .bin if not already in memory
        fidA = fopen(filename);
        if fidA==-1
            disp(['fichier non présent:' filename])
            zzz=int16(zeros(10));
        else
            zzz=[];
            zzz=int16((fread(fidA,'int16')));
            zzz=reshape(zzz,(s1*s2+6),round(length(zzz)/(s1*s2+6)));            
            fclose(fidA);
        end
    else
        fidA=1; %si le fichier est déjà en mémoire on met le marqueur à 1 pour continuer l'analyse
    end
    
    if fidA~=-1           
        frameout(i1)= frameToRead(i1,1);
        Imout=double(reshape(zzz(7:end,frameToRead(i1,2)),[s1 s2])'); %note :on tourne la figure
       if size(frameToRead,1)>1
            Imoutcell{i1}= Imout;
        end
    else
        try 
            Disp2([],['frame : ' num2str(frameToRead(i1)) ' non trouvé' ]) 
        catch
            disp([],['frame : ' num2str(frameToRead(i1)) ' non trouvé' ]) 
        end
        Imout=zeros(s2, s1);
        frameout=0;
    end
    filenameOld=filename;
end

if size(frameToRead,1)>1
    Imout= Imoutcell;
end

