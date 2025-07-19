# Keymap Documentation Improvement Ideas

## Ideas Discovered During Cleanup

### Formatting Improvements
- [ ] Standardize keymap notation (see inconsistencies between `l zm`, `<leader>zm`, `L zm`)
- [ ] Align descriptions for better readability
- [ ] Use consistent spacing (some have extra spaces, some don't)
- [ ] Decide on consistent use of command notation (`:Command` vs just description)

### Organization Ideas
- [ ] Group AI/Assistant tools into one major section (currently scattered)
- [ ] Separate plugin-specific mappings from core vim mappings
- [ ] Create a "Quick Reference" section at the top for most-used maps
- [ ] Add a table of contents for easier navigation

### Content Improvements
- [ ] Add missing descriptions for some mappings
- [ ] Clarify abbreviated descriptions (what does "gs" mean in context?)
- [ ] Add examples for complex mappings
- [ ] Document the leader key clearly at the beginning

### Cross-Reference Needs
- [ ] Many maps reference config files - should we include those references?
- [ ] Some maps have multiple variations (visual, normal modes) - document all?
- [ ] Plugin dependencies should be noted for plugin-specific maps

### Possible New Sections
- [ ] "Common Workflows" - combining multiple keymaps for tasks
- [ ] "Troubleshooting" - for when keymaps don't work
- [ ] "Customization Guide" - how to modify these mappings

### Technical Debt
- [ ] Some sections reference outdated plugins or deprecated features
- [ ] Comments indicate some maps are "hardly used" - should these be removed?
- [ ] Multiple TODO items scattered throughout - consolidate or address

### Future Considerations
- [ ] Version control friendly format (easier to diff)
- [ ] Consider generating parts of this from actual config files
- [ ] Add metadata (last updated, version compatibility)
- [ ] Create language-specific keymap files (python.md, typescript.md, etc.)

## Next Review Session Ideas
- Compare keymaps with actual usage patterns
- Identify redundant or conflicting mappings
- Consider user feedback on which maps are most valuable
- Review against Neovim best practices and conventions