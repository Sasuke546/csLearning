function gen_DS = gen_hset_new(dimension, Q, ep)

% ep = 1e-4;
gen_N = 1/ep ;
hset = haltonset(dimension, 'Skip',1e3,'Leap',1e2) ;
hset = scramble(hset,'RR2') ;
gen_DS = net(hset, gen_N) ;
gen_DS = ((2*Q) .* (gen_DS'-0.5)) ;

end