import { RuleContext } from '@alfresco/adf-extensions';

export function canTakeOwnership(context: RuleContext): boolean {

  const node = context.selection.file ? context.selection.file : context.selection.folder;

  if (!node || !node.entry) {
    return false;
  }

  if (node.entry.properties && node.entry.properties['cm:owner']) {
    const owner = node.entry.properties['cm:owner'];
    return context.profile.isAdmin && owner.id != context.profile.id;
  } else {
    return context.profile.isAdmin;
  }

}
