import { TestBed } from '@angular/core/testing';

import { TakeOwnershipService } from './take-ownership.service';

describe('TakeOwnershipService', () => {
  let service: TakeOwnershipService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TakeOwnershipService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
