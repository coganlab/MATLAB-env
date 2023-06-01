 function X=joyvel(Joy)
if ndims(Joy) == 2
    Q(1,:,:) = Joy;  
    Joy = Q;
end
 FO = diff(Joy,1,3);
 Q = zeros(size(Joy));
 Q(:,:,2:size(Joy,3)) = FO;
 X = squeeze(sqrt(Q(:,1,:).^2 + Q(:,2,:).^2));
 X(1) = X(2);
