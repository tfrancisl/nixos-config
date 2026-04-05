{self, ...}: {
  documentation.enable = false;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
