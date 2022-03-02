import { Injectable } from '@angular/core';
import { MinimalNodeEntryEntity } from '@alfresco/js-api';
import { AuthenticationService, NodesApiService } from '@alfresco/adf-core';

@Injectable({
  providedIn: 'root'
})
export class TakeOwnershipService {

  constructor(
    private nodesApiService: NodesApiService,
    private authenticationService: AuthenticationService
  ) {}

  onActionTakeOwnership(node: MinimalNodeEntryEntity): void {
    this.nodesApiService.updateNode(node.id, { properties : {
      'cm:owner': this.authenticationService.getEcmUsername()
    }});
  }

}
