\m4_TLV_version 1d: tl-x.org
\SV

   // =================================================
   // Illustrates:
   //    o mono -> IDE in iframe
   //    o makerchip-app use of local file api
   // =================================================
   m4_include_lib(['https://raw.githubusercontent.com/TL-X-org/tlv_lib/db48b4c22c4846c900b3fa307e87d9744424d916/fundamentals_lib.tlv'])
   m4_def(
      auth, -2,
      create, -1,
      load, 0,
      autosave, 1,
      compile, 1,
      commit, 2,
      push_api, 2)
\TLV ide(|_top, _app, _db)
   @m4_compile
      /ide_server
         $compile = |_top/ide_client$tlv;
   m4+ifelse(_app, app,
      \TLV
         /ide_client
            @m4_load
               $open_ide = |_top/desktop$cmd_tlv;
         /ide_server
            @m4_load
               /db
                  $tlv = |_top/desktop$cmd_tlv;
         /desktop
            @m4_autosave
               $tlv2 = $cmt_tlv && |_top/ide_server$autosave;
      , _app, new,
      \TLV
         /desktop
            @m4_load
               $tlv = |_top/ide_client$open_ide;
            @m4_autosave
               $tlv2 = |_top/ide_client$autosave;
         /ide_client
            @m4_load
               $tlv = |_top/desktop$tlv;
      )
   m4+ifelse(_db, db,
      \TLV
         /ide_server
            /db
               @m4_autosave
                  $tlv2 = $tlv && |_top/ide_client$autosave;
         /ide_client
            @m4_load
               $tlv = |_top/ide_server/db$tlv;
      )
   /ide_client
      @m4_autosave
         $autosave = $tlv
      @m4_load
         $html_css_js_etc = |_top/ide_server$html_css_js_etc;
      @m4_compile
         $results = |_top/ide_server$compile;
\TLV makerchip_today()
   |makerchip_today
      m4+ide(|makerchip_today, , db)
\TLV sandstorm()
   |sandstorm
      m4+ide(|sandstorm, app)
\TLV makerchip_app()
   |makerchip_app
      m4+ide(|makerchip_app, app, db)
\TLV makerchip_app_new()
   |makerchip_app_new
      m4+ide(|makerchip_app_new, new)
\TLV mcp()
   |mcp
      /github
         @m4_auth
            $auth = |mcp/mcp_server$auth_req;
         @m4_create
            $new_repo = |mcp/mcp_server$new_repo;
         @m4_commit
            $commit = |mcp/mcp_server$commit;
      /mcp_server
         @m4_auth
            $auth = |mcp/github$auth;
         @m4_create
            $new_repo = |mcp/mcp_client$new_repo;
         /db
            @m4_push_api
               $tlv = |mcp/github$push_api_commit;
         @m4_commit
            $commit = |mcp/mcp_client$commit && |mcp/ide_server/db$tlv2;
      /mcp_client
         @m4_load
            $html_css_js = |mcp/mcp_server$html_css_js;
      m4+ide(|mcp, db)
      /ide_client
         @m4_create
            $open_ide = |mcp/mcp_client$new_repo;
      /ide_server
         /db
            @m4_create
               $tlv = |mcp/mcp_client$new_repo;
            @m4_commit
               $tlv2 = $tlv && |mcp/mcp_server$commit;
\TLV
   m4+makerchip_today()
   m4+makerchip_app()
   m4+sandstorm()
   m4+makerchip_app_new()
   m4+mcp()
