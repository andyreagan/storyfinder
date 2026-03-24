# Storyfinder

**Real-time Entropic Event Detection**

Storyfinder is a method for finding and classifying stories in real-time text streams. It computes entropy and ambient valence of phrases, then shifts these measures over time to detect which stories are driving significant changes in language use. Building on the text partitioner of Williams et al., the approach detects convergence in language — moments when many voices start talking about the same thing — as a signal that a story is breaking.

This was developed as a research project at the [Computational Story Lab](https://compstorylab.org/) at the University of Vermont, circa 2013. The Boston Marathon bombings of April 2013 served as the primary case study.

## Authors

- Suma Desu
- Andrew Reagan
- Jake Williams
- Chris Danforth
- Peter Dodds

Department of Mathematics and Statistics, Center for Complex Systems, Computational Story Lab & the Vermont Advanced Computing Core, University of Vermont.

## Repository structure

```
storyfinder/
├── scripts/          # Python and shell scripts for data pipeline
│   ├── ngram_decomp_seg.py           # N-gram decomposition & segmentation (from v2)
│   ├── downloadParseByDay.py         # Download and parse Twitter JSON by day
│   ├── parse_from_to.py              # Parse tweets from JSON to text
│   ├── parse-most-recent-hour-to-txt.py
│   ├── clean-timeseries.py           # Clean up generated time series
│   ├── plot_correlation.py
│   ├── labMT_stopword_parser.py      # labMT word list utilities
│   ├── labMT_to_csv.py
│   ├── pydate.py                     # Date arithmetic helper
│   └── *.script, *.cron              # Shell/cron job scripts
├── data/             # labMT word lists and ambient valence data
│   ├── labMT1*.txt                   # labMT word lists at various stop-word cutoffs
│   ├── MTambVal_*.txt                # Ambient valence data
│   └── example_tweets.csv
├── figures/          # Generated PDF plots and visualizations
├── R_analysis/       # R scripts for the storyfinder algorithm
│   ├── storyFinder.R                 # Core storyfinder R implementation
│   ├── storyFinder_newDiffs.R        # Updated difference calculations
│   ├── phraseShiftOnly.R             # Phrase-level shift analysis
│   ├── allForNothing.R
│   └── ...
├── matlab/           # MATLAB scripts for plotting and geo analysis
├── perls/            # Perl text partitioner pipeline
│   ├── ratelist_partitioner_storyFinder/        # Original partitioner
│   └── ratelist_partitioner_storyFinder_newDiffs/  # Updated partitioner
├── paper/            # LaTeX paper source and build scripts
│   ├── storyfinder.body.tex          # Main paper text
│   ├── storyfinder-revtex4.pdf       # Compiled paper
│   ├── docs/                         # Final report and Boston figures
│   └── make*                         # Build scripts for various formats
└── notes.text
```

## Method overview

1. **Text partitioning**: Raw tweets are partitioned into meaningful phrase units using a rate-list partitioner (Perl pipeline in `perls/`).
2. **Entropy computation**: Conditional entropy of phrases is computed to measure language diversity — a drop in entropy signals convergence on a topic.
3. **Ambient valence**: Using the labMT word list (happiness ratings for ~10,000 English words), the emotional valence of phrases is tracked over time.
4. **Shift analysis**: Changes in entropy and valence between consecutive time windows (e.g., 15-minute intervals) are decomposed at the phrase level to identify *which* stories are driving the shift.

## Data

The `data/` directory contains labMT word lists at various stop-word exclusion thresholds (`labMT1_000.txt` through `labMT1_200.txt`) and pre-computed ambient valence matrices. The original Twitter data is not included.
