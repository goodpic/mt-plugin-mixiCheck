<?php

function smarty_function_mtmixiopengraphmeta($args, &$ctx) {

  $blog   = $ctx->stash('blog');
  if (!$blog) { return $ctx->error("Error : No blog");}
  $id     = $ctx->stash('blog_id');
  $config = $ctx->mt->db()->fetch_plugin_data('MixiCheck', "configuration:blog:$id");
  $entry  = $ctx->stash('entry');
  
  if ($entry) {
    $url         = smarty_function_mtentrypermalink($args, $ctx);
    $title       = $entry->title;
    $description = $config['mixi_excerpt'] ? $entry->excerpt : $entry->text;
  } else {
    $url         = smarty_function_mtblogurl($args, $ctx);
    $title       = $blog->name;
    $description = $blog->description;
  }
  $title  = strip_tags($title);
  $description   = strip_tags($description);
  $description   = mb_substr($description,0,150);
  $rating = $config['mixi_adult'] ? "1" : "0";
    
  $meta = <<<EOT
<meta property="og:type" content="article"/>
<meta property="og:title" content="$title" />
<meta property="og:description" content="$description" />
<meta property="og:url" content="$url"/> 
<meta property="mixi:content-rating" content="$rating" />
EOT;
  return $meta;   
}
?>