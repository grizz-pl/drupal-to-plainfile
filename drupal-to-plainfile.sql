-- drupal-to-plainfile.sql
-- ver. 0.1 by Witold Firlej (https://www.grizz.pl; https://github.com/grizz-pl)
-- get drupal nodes into plain text records with frontmatter
-- after execution just export results to txt/markdown file 

SELECT DISTINCT 
	CONCAT(
	    nr.nid, '-', REPLACE(nr.title, ' ','-'),
		'\n---',
		'\nnid: ', nr.nid,
	    '\nverID: ', nr.vid,
	    '\ntitle: ', nr.title,
	    '\nformat: ', ff.name,
	    '\ntags: ', CONCAT('\n  - ', x.tags),
	    '\ncreated: ', FROM_UNIXTIME(n.created),
	    '\nlastmod: ', FROM_UNIXTIME(n.changed),
	    '\n---\n', nr.body
    ) wpis
FROM node_revisions nr
JOIN term_node tn ON
nr.nid = tn.nid
JOIN node n ON
n.vid = nr.vid
JOIN (
	SELECT
		tn.nid
		, tn.vid
		, GROUP_CONCAT(
			td.name SEPARATOR '\n  - '
		) tags
	FROM
		term_data td
	JOIN term_node tn ON
		td.tid = tn.tid
	JOIN node n ON
		n.vid = tn.vid
	GROUP BY
		nid
) x ON
x.nid = nr.nid
JOIN filter_format ff ON
nr.format = ff.format
ORDER BY nr.nid;
