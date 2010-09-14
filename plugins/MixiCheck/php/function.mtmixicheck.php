<?
function smarty_function_mtmixicheck($args, &$ctx) {

  $blog   = $ctx->stash('blog');
  if (!$blog) { return $ctx->error("Error : No blog");}
  $id     = $ctx->stash('blog_id');
  $config = $ctx->mt->db()->fetch_plugin_data('MixiCheck', "configuration:blog:$id");
  $entry  = $ctx->stash('entry');
  $url    = smarty_modifier_encode_html(smarty_function_mtentrypermalink($args, $ctx));

  $button  = '<a href="http://mixi.jp/share.pl" class="mixi-check-button" ' 
    . ' data-key="' . $config['mixi_check_key']  . '" '
    . ' data-url="' . $url . '" '
    . ' data-button="' . $config['mixi_button']  . '" '
    . '>Check</a><script type="text/javascript" src="http://static.mixi.jp/js/share.js"></script>';

  return $button;

}
?>