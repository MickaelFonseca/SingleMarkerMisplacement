function [DATA,  MARKER_MIS, MM2] = MISP_MARK2_2 (Marker, DATA, SEGMENT, angle, j, E, Error_dir, s, Error, MM2)
% Author MF 
% October 2009
% Function creates a misplacement on a specific marker
% Function imputs
    % M_to_MIS (label of marker to induce a misplacement)
    % DATA (marker coordinates)
    % SEGMENT (label of direction virtual markers (origin, x,y,z))
    % angle (direction of misplacement (°))
    % E (magnitude of misplacement)
    % Error_dir (label for new marker)

MARK_GCS = DATA.(Marker);
MARK_LCS = zeros(size(DATA.(SEGMENT.origin),1),4);
MARK_MIS_LCS = zeros(size(DATA.(SEGMENT.origin),1),3);
MARKER_MIS  =  [Marker,'_', num2str(angle),'_', num2str(E), '_', Error_dir];
DATA.(MARKER_MIS)  =  zeros(size(DATA.(SEGMENT.origin),1),4);
marker.(MARKER_MIS) = [];

for m = 1:size(DATA.(SEGMENT.origin),1)
    % Rotation matrix from GCS to LCS (3x3)
    mat_left_fem(:,:,m) = Femur_Mat_Rot(DATA.(SEGMENT.origin)(m,:),DATA.(SEGMENT.proximal)(m,:),DATA.(SEGMENT.lateral)(m,:),DATA.(SEGMENT.anterior)(m,:) );
    % Transformation matrix (4x4)
    T = [mat_left_fem(:,1,m), mat_left_fem(:,2,m), mat_left_fem(:,3,m), (DATA.(SEGMENT.origin)(m,:))'; 0, 0, 0, 1];
    Transf = Tinv_array3(T);
    % Calculate marker coordinates in LCS
    MARK_LCS(m,:) = (Transf*[MARK_GCS(m,:)'; 1])';
    % Add an error on the marker in LCS
    MARK_MIS_LCS(m,:) = [MARK_LCS(m,1)+Error(1,1), MARK_LCS(m,2)+Error(1,2), MARK_LCS(m,3)+Error(1,3)];
    % Calculate marker coordinates in GCS
    DATA.(MARKER_MIS)(m,:) = (inv(Transf)*[MARK_MIS_LCS(m,:),1]')';
end
DATA.(MARKER_MIS)(:,4)= [];

end