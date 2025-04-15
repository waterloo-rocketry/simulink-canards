function [P_new] = solver_matrix(f,T,step,t,P0)
    % Computes solution of Matrix-valued IVP using the an explicit Runge−Kutta method.
    % P_new at time t+T, using step size step
    % P0 is a matrix

    P1=vectortomatrix(P(i,:)); 
    P1=A*P1+P1*A'+G*Q*G'; 
    P1=matrixtovector(P1);

    % Heuns method coefficients
    a = [0, 1]; 
    B = [0, 0; 
         1, 0];
    c = [1, 1]/2;
    
    % Preallocate the arrays
    P0 = matrix2vector(P0);
    t_vec = 0:step:(T+step/2);
    k = zeros(length(P0), length(a));

    % Initial value
    P_m = P0;
    
    % Main loop over time steps
    for m = 1:length(t_vec)-1
        % Compute the stages
        for n = 1:length(a)
            bk = k(:, 1:n) * B(n, 1:n)';
            P = vector2matrix(P_m); 
            f( t+(m+a(n))*step , x_m+step*bk , u );
            
            k(:, n) = f( t+(m+a(n))*step , x_m+step*bk , u );
        end
        % value at time t+m*step
        P_m1 = P_m + step * (k*c');
        P_m = P_m1;
    end

    % Output last value at time t+T
    P_new = vector2matrix(P_m);
    
    %%%%%%%%%%%%%%%%
    % % Preallocate the k array
    % t_vec = 0:step:T;
    % k = zeros(size(x0,1), size(x0,2), length(a));
    % 
    % % Initial value
    % x_m = x0;
    % 
    % % Main loop over time steps
    % for m = 1:length(t_vec)-1
    %     % Compute the stages
    %     for n = 1:length(a)
    %         %bk = k(:,:, 1:n) * B(n, 1:n)';
    %         bk = tensorprod(k(:,:, 1:n), B(n, 1:n)', 3,1);
    %         k(:,:, n) = f( t+(m+a(n))*step , x_m+step*bk , u );
    %     end
    %     % value at time t+m*step
    %     %x_m1 = x_m + step * (k*c');
    %     x_m1 = x_m + step * tensorprod(k,c', 3,1);
    %     x_m = x_m1;
    % end
    % 
    % % Output last value at time t+T
    % x_new = x_m;
    %%%%%%%%%%%%%%%%%%%%%%%%%
end

function P1=matrix2vector(P)
    P1=[];
    for i=1:length(P)
        P1=[P1 P(i, :)] ;
    end
end

function P1=vector2matrix(P)
    lng=sqrt(length(P)); 
    P1=[];
    for k=1:lng:length(P)
        P1=[P1; P(k:k+lng-1)];
    end
end