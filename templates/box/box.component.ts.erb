import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Box } from '../../models/box.model';
import { Status } from '../../models/status.enum';
import { BoxType } from '../../models/box-type.enum';

@Component({
  selector: 'app-box',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './box.component.html',
  styleUrls: ['./box.component.scss'],
})
export class BoxComponent implements OnInit {
  readonly boxTypes = BoxType;
  public box: Box | null = null;

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.route.params.subscribe(() => {
      this.box = history.state;
      this.addValue();
    });
  }

  public turnOn(): void {
    if (this.box) this.box.value = Status.ON;
  }

  public turnOff(): void {
    if (this.box) this.box.value = Status.OFF;
  }

  public calculate(increase: boolean) {
    if (this.box)
      this.box.value = increase
        ? ++(this.box.value as number)
        : --(this.box.value as number);
  }

  private addValue(): void {
    switch (this.box?.type) {
      case BoxType.BOOLEAN:
        this.box.value = Status.OFF;
        break;
      case BoxType.NUMBER:
        this.box.value = 0;
        break;
      case BoxType.STRING:
        this.box.value = '';
        break;
      default:
        break;
    }
  }
}
