package MixiCheck;

use strict;
use utf8;
use warnings;
use MT::Util qw( remove_html );

sub _hdlr_opengraph_meta {

    my ($ctx, $args, $cond) = @_;
    my $plugin    = MT->component("MixiCheck");
    my $blog      = $ctx->stash('blog') or return '';
    my $config    = $plugin->get_config_hash("blog:" . $blog->id);

    my $entry     = $ctx->stash('entry');
    my $url       = $entry ? $entry->permalink : $blog->site_url;
    my $title     = $entry ? $entry->title : $blog->name;

    my $description = $blog->description;
    my $assets_str;
    if ($entry) {
        $description = $config->{mixi_excerpt} ? $entry->excerpt : $entry->text;
        use MT::Asset;
        use MT::ObjectAsset;
        my @assets = MT::Asset->load({ class => 'image'}, {
            join => MT::ObjectAsset->join_on(
                'asset_id',{ object_ds => MT::Entry->datasource, object_id => $entry->id})
        });
        my $count = 0;
        for my $asset (@assets) {
            $assets_str .= '<meta property="';
            $assets_str .= ($count == 0) ? 'og:image" content="' : 'mixi:image" content="';
            my %arg;
            $arg{Width} = 500;
            $arg{Height} = 333;
            my ($url, $w, $h) = $asset->thumbnail_url(%arg);
            $assets_str .= $url . '"/>';

            $count++;
        }
    }

    my @words = split /\s+/, remove_html($description);
    $description = join '', @words;
    $description = substr($description, 0, 200);

    my $meta = '<meta property="og:site_name" content="' . $blog->name . '"/>';
    if ($config->{mixi_adult}) {
        $meta .= '<meta property="mixi:content-rating" content="1" />';
    }
    $meta .=<<"EOF";
<meta property="og:title" content="$title"/>
<meta property="og:type" content="article"/>
<meta property="og:url" content="$url"/>
<meta property="og:description" content="$description"/>
$assets_str
EOF
    return $meta;
}

sub _hdlr_mixi_check {
    my ($ctx, $args, $cond) = @_;
    my $plugin    = MT->component("MixiCheck");
    my $blog      = $ctx->stash('blog') or return '';
    my $config    = $plugin->get_config_hash("blog:" . $blog->id);
    my $entry     = $ctx->stash('entry');
    my $url       = $entry ? $entry->permalink : $blog->site_url;

    my $button  = '<a href="http://mixi.jp/share.pl" class="mixi-check-button" ' 
        . ' data-key="' . $config->{'mixi_check_key'}  . '" '
        . ' data-url="' . $url . '" '
        . ' data-button="' . $config->{'mixi_button'}  . '" '
        . '>Check</a><script type="text/javascript" src="http://static.mixi.jp/js/share.js"></script>';

    return $button;
}

1;
