function abbr_candidates --description 'Frequent two-word commands with no abbr'
    # Usage: abbr_candidates [file of `abbr --show` lines]
    # The file is for non-interactive shells, which don't load the abbrs.
    if set -q argv[1]
        set -f abbrs (cat $argv[1])
    else
        set -f abbrs (abbr --show)
    end
    set -l expansions (string replace -r '^abbr -a .*?-- \S+ ' '' -- $abbrs | string trim -c "'")

    # Multi-line entries become one line, so continuation lines don't count.
    set -l lines (history -z | tr '\n\0' ' \n')
    set -l prefixes (string match -r --groups-only '^\s*([a-z][\w.-]*\s+[a-z][\w-]*)' -- $lines | string replace -ra '\s+' ' ')

    printf '%s\n' $prefixes | sort | uniq -c | sort -rn | string trim | while read -l count prefix
        test $count -ge 20; or break
        # Covered when an abbr expands to this prefix or longer (`gpu` covers
        # "git push"), or to its first word (`gwa` covers "gwa_cmd feature").
        string match -q -- "$prefix*" $expansions; and continue
        contains -- (string split -f1 ' ' -- $prefix) $expansions; and continue
        echo $count $prefix
    end
end
