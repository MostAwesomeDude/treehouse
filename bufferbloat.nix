{ ... }:
{
  # Request fq_codel as the default qdisc. This is a one-line fix for
  # bufferbloat, or at least a good anti-bufferbloat measure.
  boot.kernel.sysctl."net.core.default_qdisc" = "fq_codel";
}
