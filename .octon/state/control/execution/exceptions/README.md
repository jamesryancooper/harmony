# Exception Control Roots

`state/control/execution/exceptions/**` is the canonical live control family
for normalized `ExceptionLease` artifacts.

Each lease must live as its own file under
`state/control/execution/exceptions/leases/`.

Root-level aggregate lease files are not canonical and must not be recreated.
