#### Server CLI

wolfSSL server:
```
examples/server/server -v 4 -x -d -p 44333
```

openSSL server:
```
./apps/openssl s_server -key key.pem -cert cert.pem -port 12345
```

wolfSSL options:
```
-p <num>    Port to listen on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/server-cert.pem
-k <file>   Key file,                   default ./certs/server-key.pem
-A <file>   Certificate Authority file, default ./certs/client-cert.pem
-R <file>   Create Ready file for external monitor default none
-D <file>   Diffie-Hellman Params file, default ./certs/dh2048.pem
-Z <num>    Minimum DH key bits,        default 1024
-d          Disable client cert check
-b          Bind to any interface instead of localhost only
-s          Use pre Shared keys
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-f          Fewer packets/group messages
-r          Allow one client Resumption
-N          Use Non-blocking sockets
-S <str>    Use Host Name Indication
-w          Wait for bidirectional shutdown
-x          Print server errors but do not close connection
-i          Loop indefinitely (allow repeated connections)
-e          Echo data mode (return raw bytes received)
-B <num>    Benchmark throughput using <num> bytes and print stats
-g          Return basic HTML web page
-C <num>    The number of connections to accept, default: 1
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-U          Update keys and IVs before sending
-K          Key Exchange for PSK not using (EC)DHE
-y          Pre-generate Key Share using FFDHE_2048 only
-Y          Pre-generate Key Share using P-256 only
-T [aon]    Do not generate session ticket
            No option affects TLS 1.3 only, 'a' affects all protocol versions,
            'o' affects TLS 1.2 and below only
            'n' affects TLS 1.3 only
-F          Send alert if no mutual authentication
-2          Disable DH Prime check
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```


#### Client CLI

wolfSSL options:
```
-? <num>    Help, print this usage
            0: English, 1: Japanese
--help      Help, in English
-h <host>   Host to connect to, default 127.0.0.1
-p <num>    Port to connect on, not 0, default 11111
-v <num>    SSL version [0-4], SSLv3(0) - TLS1.3(4)), default 3
-V          Prints valid ssl version numbers, SSLv3(0) - TLS1.3(4)
-l <str>    Cipher suite list (: delimited)
-c <file>   Certificate file,           default ./certs/client-cert.pem
-k <file>   Key file,                   default ./certs/client-key.pem
-A <file>   Certificate Authority file, default ./certs/ca-cert.pem
-Z <num>    Minimum DH key bits,        default 1024
-b <num>    Benchmark <num> connections and print stats
-B <num>    Benchmark throughput using <num> bytes and print stats
-d          Disable peer checks
-D          Override Date Errors example
-e          List Every cipher suite available,
-g          Send server HTTP GET
-u          Use UDP DTLS, add -v 2 for DTLSv1, -v 3 for DTLSv1.2 (default)
-m          Match domain name in cert
-N          Use Non-blocking sockets
-r          Resume session
-w          Wait for bidirectional shutdown
-M <prot>   Use STARTTLS, using <prot> protocol (smtp)
-f          Fewer packets/group messages
-x          Disable client cert/key loading
-X          Driven by eXternal test case
-j          Use verify callback override
-n          Disable Extended Master Secret
-H <arg>    Internal tests [defCipherList, exitWithRet, verifyFail, useSupCurve,
                            loadSSL, disallowETM]
-J          Use HelloRetryRequest to choose group for KE
-K          Key Exchange for PSK not using (EC)DHE
-I          Update keys and IVs before sending data
-y          Key Share with FFDHE named groups only
-Y          Key Share with ECC named groups only
-1 <num>    Display a result by specified language.
            0: English, 1: Japanese
-2          Disable DH Prime check
-6          Simulate WANT_WRITE errors on every other IO send
-7          Set minimum downgrade protocol version [0-4]  SSLv3(0) - TLS1.3(4)
```

## AFLNet Cli options

```
aflnet/afl-fuzz [ options ] -- /path/to/fuzzed_app [ ... ]

Required parameters:
  -i dir        - input directory with test cases
  -o dir        - output directory for fuzzer findings

Execution control settings:
  -f file       - location read by the fuzzed program (stdin)
  -t msec       - timeout for each run (auto-scaled, 50-1000 ms)
  -m megs       - memory limit for child process (50 MB)
  -Q            - use binary-only instrumentation (QEMU mode)

Fuzzing behavior settings:

  -d            - quick & dirty mode (skips deterministic steps)
  -n            - fuzz without instrumentation (dumb mode)
  -x dir        - optional fuzzer dictionary (see README)

Settings for network protocol fuzzing (AFLNet):

  -N netinfo    - server information (e.g., tcp://127.0.0.1/8554)
  -P protocol   - application protocol to be tested (e.g., RTSP, FTP, DTLS12, DNS, SMTP, SSH, TLS)
  -D usec       - waiting time (in micro seconds) for the server to initialize
  -W msec       - waiting time (in miliseconds) for receiving the first response to each input sent
  -w usec       - waiting time (in micro seconds) for receiving follow-up responses
  -K            - send SIGTERM to gracefully terminate the server (see README.md)
  -E            - enable state aware mode (see README.md)
  -R            - enable region-level mutation operators (see README.md)
  -F            - enable false negative reduction mode (see README.md)
  -c cleanup    - name or full path to the server cleanup script (see README.md)
  -q algo       - state selection algorithm (See aflnet.h for all available options)
  -s algo       - seed selection algorithm (See aflnet.h for all available options)

Other stuff:

  -T text       - text banner to show on the screen
  -M / -S id    - distributed mode (see parallel_fuzzing.txt)
  -C            - crash exploration mode (the peruvian rabbit thing)
```

## Library Equivalence

The max. lines for coverage should be the same for tlsanvil, tlspuffin and profuzzbench

* Disable optimization -O0
* Use clang everywhere
* Use same clang version everywhere
* Use same version of gcovr
* Use same architecture
* Use same config flags


# Observed crashes

* AFLnwe: https://github.com/thuanpv/aflnwe/issues/2
* AFLnwe: https://github.com/thuanpv/aflnwe/issues/1
* AFLnwe: https://github.com/thuanpv/aflnwe/issues/3
* AFLnwe: https://github.com/thuanpv/aflnwe/issues/4
* TLS-Anvil: https://github.com/tls-attacker/TLS-Attacker/issues/152
* StateAFL: https://github.com/stateafl/stateafl/issues/11
