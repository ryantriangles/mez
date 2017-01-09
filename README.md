Running `mez` will update the database and display a table comparing the current
sizes of your folder sets to their sizes the last day you scanned (whether that
was yesterday or 3 years ago). However, running two scans back-to-back will not
generate new comparison points; there is only one figure recorded per day,
repeated scans will update that figure and then compare to yesterday again.

```
FOLDERSET                                              SIZE (MB)     CHANGE (MB)
--------------------------------------------------------------------------------
BACKUPS                                                1,556,010            -170
HOME MOVIES                                            1,303,734         +29,776
MUSIC                                                    241,652
MY PHOTOS                                                108,703            -241
OTHER PEOPLE'S PHOTOS                                     31,183
TEMPORARY FILES                                           16,901            +471
PROJECTS                                                   2,481              +8
LECTURE NOTES                                                 74
--------------------------------------------------------------------------------
TOTAL SIZE: 3,260,736                                      TOTAL CHANGE: -29,884
```

Your configuration file is located at `~/.mez/folders.json` (Linux, macOS) or
`%localappdata%/mez/folders.json` (Windows), and should look like this:

```json
{
    "projects": [
        "~/work projects",
        "~/personal projects" ],
    "books": [
        "~/books/fiction",
        "~/books/nonfiction" ]
}
```

The values are arrays, so that you can assign a single name to a collection of
folders if you so choose.

All figures are [IEC standard](https://en.wikipedia.org/wiki/Kilobyte#1000_bytes) (1 kilobyte = 1,000 bytes).
