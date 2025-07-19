# Keymap Ergonomics

This document details the ergonomic principles behind my Neovim keymap system.

## Touch Typing Ergonomics

### Key Accessibility Rankings

1. **Most Accessible** - Home row keys (`asdfg`, `hjkl;`)
   - These keys are at the base position for my fingers
   - Require minimal movement and effort

2. **Easily Accessible** - Adjacent to home row (`qwert`, `yuiop`, `zxcvb`, `nm,./`)
   - Require slight finger movement from home position
   - Still comfortable for frequent use

3. **Less Accessible** - Number row and special characters
   - Require significant finger movement from home position
   - Less ideal for frequent operations

4. **Least Accessible** - Modifier combinations, far corner keys
   - Require hand position changes or stretching
   - Should be reserved for infrequent operations

### Combination Factors

- **Sequence Length**: Shorter sequences (2-3 keys) are preferred over longer ones
- **Hand Alternation**: Sequences that alternate between hands are easier to type
- **Chord Complexity**: Simple modifier chords (Ctrl+key) are easier than complex ones (Ctrl+Shift+Alt+key)

## Mental Models

- **Mnemonic Value**: Mappings should have some logical connection to their function
- **Consistency**: Similar functions should have similar mapping patterns
- **Hierarchy**: More general operations should have simpler mappings than specific variations

## Usage Frequency Guidelines

Usage frequency should directly inform mapping ergonomics:

1. **High Frequency** (many times per hour)
   - Assign most ergonomic keys/sequences
   - Prioritize speed over mnemonic value if necessary

2. **Medium Frequency** (several times per day)
   - Balance ergonomics and mnemonics
   - Can use slightly longer sequences if they're memorable

3. **Low Frequency** (occasionally)
   - Prioritize memorability over ergonomics
   - Can use longer sequences or less ergonomic positions
   - Consider whether a mapping is even necessary

## Measurement and Evaluation

When evaluating a keymap for ergonomic efficiency, consider:

1. Physical effort required
2. Cognitive load to remember the mapping
3. Frequency of use in typical workflows
4. Consistency with existing mapping patterns

## Future Improvements

- Empirical measurement of keymap usage frequency
- Heat mapping of finger movement and effort
- Systematic evaluation of existing mappings against ergonomic principles