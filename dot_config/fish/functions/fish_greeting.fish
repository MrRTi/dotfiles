function fish_greeting
    # One random line per shell instead of fish's welcome text. Generators use
    # builtins (plus one `date`), so the greeting adds at most a few ms.
    set -l cache $XDG_CACHE_HOME/fish/greeting-abbr-candidates
    set -l generators abbr year
    test -s $cache; and set -a generators candidate

    switch (random choice $generators)
        case abbr
            # `abbr --show` lines look like: abbr -a -- gs 'git status'
            set -l line (random choice (abbr --show))
            set -l parts (string replace -r '^abbr -a .*-- ' '' -- $line | string split -m1 ' ')
            set_color brblack
            echo "abbr reminder: $parts[1] → "(string trim -c "'" -- $parts[2])
        case year
            set -l now (date '+%Y %j' | string split ' ')
            set -l year $now[1]
            set -l day (string trim -l -c 0 -- $now[2])
            set -l days 365
            if test (math $year % 4) -eq 0 -a \( (math $year % 100) -ne 0 -o (math $year % 400) -eq 0 \)
                set days 366
            end
            set -l pct (math -s0 "100 * $day / $days")
            set -l filled (math -s0 "$pct / 5")
            set_color brblack
            echo $year (string repeat -n $filled █)(string repeat -n (math 20 - $filled) ░) "$pct% · day $day of $days"
        case candidate
            # "count prefix" lines, written by the background refresh below.
            set -l entry (string split -m1 ' ' -- (random choice (cat $cache)))
            set_color brblack
            echo "abbr candidate: $entry[2] ($entry[1]×)"
    end
    set_color normal

    # Scanning ~30k history entries takes ~75 ms, so refresh at most daily in a
    # detached shell; the next greeting picks up the result. That shell skips
    # config.fish (non-interactive), so it gets the abbrs through a file.
    # NOTE: not --private or --no-config: both make `history` empty.
    if not test -s $cache; or test (path mtime -R $cache) -gt 86400
        mkdir -p (path dirname $cache)
        abbr --show >$cache.abbrs
        fish -c "abbr_candidates $cache.abbrs > $cache.tmp; and mv $cache.tmp $cache" 2>/dev/null &
        disown
    end
end
