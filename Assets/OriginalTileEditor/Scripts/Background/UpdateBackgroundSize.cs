using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateBackgroundSize : ECSSystem
{
    private void Update()
    {
        foreach (var background in GetEntitiesItem1<Background>())
        {
            var mainCamera = GetEntityItem1<MainCamera>().camera;

            var topRight = Vector3.one;
            var bottomLeft = Vector3.zero;

            background.viewWorldLeftBorder = mainCamera.ViewportToWorldPoint(bottomLeft).x;
            background.viewWorldRightBorder = mainCamera.ViewportToWorldPoint(topRight).x;
            background.viewWorldBottomBorder = mainCamera.ViewportToWorldPoint(bottomLeft).y;
            background.viewWorldTopBorder = mainCamera.ViewportToWorldPoint(topRight).y;
            
            background.screenSize = mainCamera.ViewportToScreenPoint(topRight)
                                    - mainCamera.ViewportToScreenPoint(bottomLeft);

            background.worldSize = mainCamera.ViewportToWorldPoint(topRight)
                                   - mainCamera.ViewportToWorldPoint(bottomLeft);

            var localScale = (Vector3)background.worldSize;
            localScale.z = 1;
            background.transform.localScale = localScale;


        }
    }
}