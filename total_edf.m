function price = total_edf(mu1, mu2, sigma1, sigma2, rho, alpha, beta, K)
  %pkg load statistics;
  %parameters for Z
  mu = mu1 + mu2;
  sigma = sqrt(sigma1^2 + sigma2^2 + 2*rho*alpha*beta*sigma1*sigma2);
  
  n = 1000;
  x = zeros(n,1);
  sum = 0;
  for i=1:n
    x(i) = random('lognormal', mu, sigma) -K;
    sum =sum + x(i);
  end
  
  price = sum/n;
  figure;
  histogram(x);
end