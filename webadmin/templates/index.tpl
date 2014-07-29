{*initialize a variable needed later in the page*}
{php}
global $unique, $ei;
$unique = array();
$ei = 0;
{/php}
<html>
	<head>
		<title>{$page_title} :: {$app_title}</title>
		<link rel="stylesheet" href="style.css"/>
	</head>
<body>
<h1>{$app_title}</h1>
<h2>{$page_title}</h2>
<hr/>
<a href="#stats">Jump to statistics</a>
<div>
	<h3>Entries</h3>
	<table>
		<thead>
			<tr>
				<td>#</td>
				<td>Username</td>
				<td>Timestamp</td>
				<td>Text</td>
				<td>Id</td>
			</tr>
		</thead>
	<tbody>
		{foreach from=$entries item=e name=en}
			{if $smarty.foreach.en.index % 2 == 0}
		<tr class="even">
			{else}
		<tr class="odd">
			{/if}
			<td>{$smarty.foreach.en.index+1}</td> {* 0 indexed  *}
			<td><a href="http://www.twitter.com/{$e->username}">{$e->username}</a></td>
			<td>{$e->timestamp|date_format:'Y M d H:i:s'}</td>
			<td>{$e->text}</td>
			<td><a href="http://www.twitter.com/{$e->username}/status/{$e->id}">{$e->id}</a></td>
		</tr>
{php}
global $unique, $entries, $ei;
$unique[] = $entries[$ei++]->username;
{/php}
		{/foreach}
	</tbody>
</table>
<h3>Username frequency</h3>
<p class="note"><span class="dup">Duplicate usernames</span> <span class="sin">Single occurances</span></p>
{php}
global $unique;
$unique = array_count_values($unique);
ksort($unique);
foreach($unique as $u=>$f){ 
	echo '<span class="'.($f > 1 ? 'dup' : 'sin').'" title="'.$f.'">'.$u.'</span> '; 
}
{/php}
<br/>
<h3><a name="stats">Statistics</a></h3>
<div>Number of entries: <span id="total">{$smarty.foreach.en.total}</span></div> {* optimized *}
<div>Number of unique usernames: {php}global $unique; echo count($unique);{/php}</div>{* this would have had crazy runtime, something like 4N *}
</body></html>
