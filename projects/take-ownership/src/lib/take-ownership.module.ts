import { NgModule } from '@angular/core';
import { EffectsModule } from '@ngrx/effects';

import { ExtensionService, provideExtensionConfig } from '@alfresco/adf-extensions';
import { TranslationService } from '@alfresco/adf-core';

import { TakeOwnershipEffects } from './effects/take-ownership.effects';
import { canTakeOwnership } from './evaluators';

@NgModule({
  imports: [ EffectsModule.forFeature([TakeOwnershipEffects]) ],
  providers: [
      provideExtensionConfig(['take-ownership.json']),
  ]
})
export class TakeOwnershipModule {
  constructor(extensions: ExtensionService, translation: TranslationService) {
    translation.addTranslationFolder('take-ownership', 'assets/take-ownership');
    extensions.setEvaluators({
      'aca.canTakeOwnerShip': canTakeOwnership
    });
  }
}
