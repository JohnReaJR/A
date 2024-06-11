{
    "auth":"binary",
     "file":"/root/cfg/auth.txt",
    "executable":"/root/auth.sh",
    "banner":"linklayer by Newtoolsworks",
    "limit_conn_single":-1,
    "limit_conn_request":-1,
     "services":[
{
 "type":"httpdual",
        "cfg":{
          "Listen":"0.0.0.0:8000"
        }
},

       {
         "type":"tls",
         "cfg":{
          "Cert":"/root/cfg/cert.pem",
           "Key":"/root/cfg/key.pem",
           "Listen":"0.0.0.0:8001"
         }
       },
       {
        "type":"http",
        "cfg":{
          "Response":"HTTP/1.1 206 OK\r\n\r\n",
          "Listen":"0.0.0.0:8002"

        }
       },
	{
	"type":"http",
        "cfg":{
          "Response":"HTTP/1.1 200 OK\r\n\r\n",
          "Listen":"0.0.0.0:80"

        }
        },
       {"type":"httptls",
       "cfg":{
         "Http":{
            "Response":"HTTP/1.1 206 OK\r\n\r\n"
         },
         "TLS":{
          "Cert":"/root/cfg/cert.pem",
          "Key":"/root/cfg/key.pem"
         },
         "Listen":"0.0.0.0:8990"
       }
      },

{"type":"httptls",
       "cfg":{
         "Http":{
            "Response":"HTTP/1.1 200 OK\r\n\r\n"
         },
         "TLS":{
          "Cert":"/root/cfg/cert.pem",
          "Key":"/root/cfg/key.pem"
         },
         "Listen":"0.0.0.0:443"
       }
     
},
       {"type":"udp",
       "cfg":{
        "listen":":36718","exclude":"53,5300","net":"enp1s0","cert":"/root/layers/cfgs/my.crt","key":"/root/layers/cfgs/my.key","obfs":"yourpassword","max_conn_client":500000
      }
      },
       
       {"type":"dnstt",
       "cfg":{
         "Domain":"ns.linklayer.com",
         "Net":"enp1s0"
       }
      }
     ]
   }
