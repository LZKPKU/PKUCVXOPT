The (discrete) optimal transport problem
$$
\begin{split}
\min &\sum_{i=1}^N \sum_{j=1}^N c_{ij}x_{ij}\\
\text{s.t.} &\sum_{j=1}^Nx_{ij}=\mu_i,i=1,2,...,N\\
&\sum_{i=1}^Nx_{ij} = \nu_j,j=1,2,...,N\\
&x_{ij}\geq 0,i,j=1,2,...,N

\end{split}
$$
Has the Lagrangian
$$
\begin{split}
L(x,\alpha,\beta) =&\sum_{i=1}^N \sum_{j=1}^N c_{ij}x_{ij}-\sum_{i=1}^N\alpha_i(\sum_{j=1}^Nx_{ij}-\mu_i)
                                                                                                   -\sum_{j=1}^N\beta_j(\sum_{i=1}^Nx_{ij}-\nu_j)\\
=&\sum_{i=1}^N \sum_{i=1}^N(c_{ij}-\alpha_i-\beta_j)x_{ij}+\sum_{i=1}^N(\alpha_i\mu_i+\beta_i\nu_i)
\end{split}
$$
So we have
$$
\begin{split}
g(\alpha,\beta)=&\inf\limits_x L(x,\alpha,\beta)\\
=&\begin{cases}
\sum_{i=1}^N(\alpha_i\mu_i+\beta_i\nu_i) &,if\ \forall i,j=1,2,...,N,\alpha_i+\beta_j \leq c_{ij} \\
-\infty &,otherwise
\end{cases}
\end{split}
$$
Then the dual problem follows as:
$$
\begin{split}
\min \limits_{\alpha,\beta}& \sum_{i=1}^N (\alpha_i\mu_i+\beta_i\nu_i)\\
\text{s.t.}& \alpha_i+\beta_j\leq c_{ij},\forall i,j=1,2,...,N
\end{split}
$$

Furthermore, this can be expressed as:
$$
\begin{split}
\min \limits_{\alpha,\beta}& \mu^T\alpha+\nu^T\beta\\
\text{s.t.}\ & diag\{\alpha\}E+Ediag\{b\} \leq C
\end{split}
$$
in which the inequality holds element-wise.