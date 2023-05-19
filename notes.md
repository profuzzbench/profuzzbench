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

AFLnwe race condition without -f flag:
```
[-] PROGRAM ABORT : Short read from input file
         Location : get_test_case(), afl-fuzz.c:468
```

race condition with -f flag:

```
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7dec859 in __GI_abort () at abort.c:79
#2  0x0000555555568196 in DFL_ck_alloc_nozero (size=4294967295) at alloc-inl.h:114
#3  DFL_ck_alloc (size=4294967295) at alloc-inl.h:136
#4  get_test_case (fsize=<optimized out>) at afl-fuzz.c:468
#5  0x000055555556856f in send_over_network () at afl-fuzz.c:578
#6  0x00005555555694cf in run_target (argv=0x7fffffffe980, timeout=40) at afl-fuzz.c:2687
#7  0x000055555556d10f in common_fuzz_stuff (argv=0x7fffffffe980, out_buf=0x5555556b7258 "\026\003\001", len=<optimized out>) at afl-fuzz.c:4906
#8  0x000055555556e902 in fuzz_one (argv=<optimized out>) at afl-fuzz.c:6774
#9  0x0000555555559bb8 in main (argc=29, argv=<optimized out>) at afl-fuzz.c:8396
```


StateAFL -K flag:
```
#0  0x0000000000925822 in map_delete_balance ()
#1  0x000000000092526d in map_remove_element ()
#2  0x00000000009254e8 in map_destroy ()
#3  0x00000000009247c1 in end_state_tracer () at afl-llvm-rt-state-tracer.o.c:1879
#4  0x00007ffff7fe0f6b in _dl_fini () at dl-fini.c:138
#5  0x00007ffff7dd28a7 in __run_exit_handlers (status=0, listp=0x7ffff7f78718 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true, run_dtors=run_dtors@entry=true) at exit.c:108
#6  0x00007ffff7dd2a60 in __GI_exit (status=<optimized out>) at exit.c:139
#7  0x0000000000922d77 in tracer_signal_handler (signum=15) at afl-llvm-rt-state-tracer.o.c:319
```



```
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7d94859 in __GI_abort () at abort.c:79
#2  0x00007ffff7e072da in __malloc_assert (
    assertion=assertion@entry=0x7ffff7f2b8a8 "(old_top == initial_top (av) && old_size == 0) || ((unsigned long) (old_size) >= MINSIZE && prev_inuse (old_top) && ((unsigned long) old_end & (pagesize - 1)) == 0)",
    file=file@entry=0x7ffff7f273d6 "malloc.c", line=line@entry=2379, function=function@entry=0x7ffff7f2c030 <__PRETTY_FUNCTION__.13066> "sysmalloc") at malloc.c:298
#3  0x00007ffff7e0993f in sysmalloc (nb=nb@entry=64, av=av@entry=0x7ffff7f5eb80 <main_arena>) at malloc.c:2379
#4  0x00007ffff7e0a793 in _int_malloc (av=av@entry=0x7ffff7f5eb80 <main_arena>, bytes=bytes@entry=48) at malloc.c:4141
#5  0x00007ffff7e0c154 in __GI___libc_malloc (bytes=48) at malloc.c:3058
#6  0x0000000000a4ff8c in new_alloc_record (addr=0x7fffffffc8e0, size=80) at afl-llvm-rt-state-tracer.o.c:760
#7  0x0000000000a5014e in new_stack_alloc_record (addr=0x7fffffffc8e0, size=80) at afl-llvm-rt-state-tracer.o.c:850
#8  0x0000000000850abb in ossl_store_unregister_loader_int (scheme=0xa76576 "file") at crypto/store/store_register.c:242
#9  0x0000000000777ef2 in OPENSSL_cleanup () at crypto/init.c:359
#10 0x00007ffff7db88a7 in __run_exit_handlers (status=0, listp=0x7ffff7f5e718 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true, run_dtors=run_dtors@entry=true) at exit.c:108
#11 0x00007ffff7db8a60 in __GI_exit (status=<optimized out>) at exit.c:139
#12 0x0000000000a4ff57 in tracer_signal_handler (signum=15) at afl-llvm-rt-state-tracer.o.c:319
#13 <signal handler called>
#14 _int_malloc (av=av@entry=0x7ffff7f5eb80 <main_arena>, bytes=bytes@entry=32) at malloc.c:4116
#15 0x00007ffff7e0c154 in __GI___libc_malloc (bytes=32) at malloc.c:3058
#16 0x0000000000a51ac0 in tracer_dump () at afl-llvm-rt-state-tracer.o.c:1002
#17 0x0000000000a50607 in net_send (buf=0xe3bd40, size=1421) at afl-llvm-rt-state-tracer.o.c:1124
#18 0x0000000000a50784 in trace_write (fd=5, buf=0xe3bd40, size=1421) at afl-llvm-rt-state-tracer.o.c:1171
#19 0x0000000000616292 in sock_write (b=0xce3f40, in=0xe3bd40 "\026\003\003", inl=1421) at crypto/bio/bss_sock.c:143
#20 0x000000000060b10f in bwrite_conv (bio=0xce3f40, data=0xe3bd40 "\026\003\003", datal=1421, written=0x7fffffffd928) at crypto/bio/bio_meth.c:77
#21 0x0000000000607c03 in bio_write_intern (b=0xce3f40, data=0xe3bd40, dlen=<optimized out>, written=0x7fffffffd928) at crypto/bio/bio_lib.c:343
#22 0x00000000006078bd in BIO_write (b=0xce3f40, data=0xe3bd40, dlen=1421) at crypto/bio/bio_lib.c:363
#23 0x000000000060325b in buffer_ctrl (b=0xce6cb0, cmd=<optimized out>, num=0, ptr=0x0) at crypto/bio/bf_buff.c:367
#24 0x0000000000608c22 in BIO_ctrl (b=0xce6cb0, cmd=11, larg=<optimized out>, parg=0x0) at crypto/bio/bio_lib.c:528
#25 0x000000000056f259 in statem_flush (s=0xd13820) at ssl/statem/statem.c:904
#26 0x00000000005984d9 in ossl_statem_server_post_work (s=0xd13820, wst=<optimized out>) at ssl/statem/statem_srvr.c:946
#27 0x000000000056db4d in write_state_machine (s=0xd13820) at ssl/statem/statem.c:872
#28 state_machine (s=0xd13820, server=<optimized out>) at ssl/statem/statem.c:444
#29 0x000000000053502a in ssl3_write_bytes (s=0xd13820, type=23, buf_=0xd04410, len=<optimized out>, written=0x7fffffffdd28) at ssl/record/rec_layer_s3.c:400
#30 0x00000000004f2daf in ssl_write_internal (s=0xd13820, buf=0xd04410, num=435, written=0x7fffffffdd28) at ssl/ssl_lib.c:2018
#31 0x00000000004f2ffd in SSL_write (s=0xd13820, buf=0xd04410, num=435) at ssl/ssl_lib.c:2095
#32 0x000000000047514a in sv_body (s=<optimized out>, stype=<optimized out>, prot=<optimized out>, context=<optimized out>) at apps/s_server.c:2659
#33 0x00000000004bf538 in do_server (accept_sock=0x1, host=0x0, port=0x0, family=<optimized out>, type=<optimized out>, protocol=<optimized out>, cb=0x473a90 <sv_body>, context=0x0, naccept=1, bio_s_out=0xc15c60)
    at apps/lib/s_socket.c:345
#34 0x000000000046f778 in s_server_main (argc=<optimized out>, argv=<optimized out>) at apps/s_server.c:2233
#35 0x000000000043c9b1 in do_cmd (prog=0xc677d0, argc=9, argv=0x7fffffffe840) at apps/openssl.c:491
#36 0x000000000043c326 in main (argc=9, argv=0x7fffffffe840) at apps/openssl.c:303
```