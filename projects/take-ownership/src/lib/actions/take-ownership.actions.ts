import { Action } from '@ngrx/store';
import { MinimalNodeEntryEntity } from '@alfresco/js-api';

export const TAKE_OWNERSHIP_ACTION = 'TAKE_OWNERSHIP_ACTION';

export class TakeOwnershipAction implements Action {
  readonly type = TAKE_OWNERSHIP_ACTION;
  constructor(public payload: MinimalNodeEntryEntity) {}
}
