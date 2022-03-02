import { ConfirmDialogComponent } from '@alfresco/adf-content-services';
import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Actions, Effect, ofType } from '@ngrx/effects';
import { map } from 'rxjs/operators';

import { TAKE_OWNERSHIP_ACTION, TakeOwnershipAction } from '../actions/take-ownership.actions';
import { TakeOwnershipService } from '../take-ownership.service';

@Injectable()
export class TakeOwnershipEffects {

  constructor(private actions$: Actions,
    private takeOwnershipService: TakeOwnershipService,
    private dialogRef: MatDialog) {}

  @Effect({ dispatch: false })
  takeOwnership$ = this.actions$.pipe(
    ofType<TakeOwnershipAction>(TAKE_OWNERSHIP_ACTION),
    map((action) => {
      if (action.payload) {

        const dialogRef = this.dialogRef.open(ConfirmDialogComponent, {
          data: {
            title: 'ACA.DIALOGS.CONFIRM_TAKE_OWNERSHIP.TITLE',
            message: 'ACA.DIALOGS.CONFIRM_TAKE_OWNERSHIP.MESSAGE',
            yesLabel: 'APP.DIALOGS.CONFIRM_LEAVE.YES_LABEL',
            noLabel: 'APP.DIALOGS.CONFIRM_LEAVE.NO_LABEL'
          },
          minWidth: '250px'
        });

        dialogRef.afterClosed().subscribe((result) => {
          if (result === true) {
            this.takeOwnershipService.onActionTakeOwnership(action.payload);
          }
        });

      }
    })
  );

}
